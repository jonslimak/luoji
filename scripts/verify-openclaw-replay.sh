#!/usr/bin/env bash
set -euo pipefail

# Verify OpenAI replay stability after patching OpenClaw:
# 1) Run deterministic two-turn session
# 2) Confirm tool call IDs retain call|fc shape
# 3) Fail on reasoning-pairing 400 in session/logs

SESSION_ID="replay-gate-$(date +%Y%m%d-%H%M%S)"
MODEL="${MODEL:-openai/gpt-5.1-codex}"
AGENT_NAME="${AGENT_NAME:-main}"
OPENCLAW_HOME="${OPENCLAW_HOME:-$HOME/.openclaw}"
OPENCLAW_LOG_DIR="${OPENCLAW_LOG_DIR:-/tmp/openclaw}"
OPENCLAW_BIN="${OPENCLAW_BIN:-}"
SKIP_LOG_CHECK=0
SUPPORTS_MODEL_FLAG=0

TURN1_MESSAGE='Use the exec tool exactly once to run: printf replay_gate_tool_ok . After the tool result, reply with a short acknowledgment sentence.'
TURN2_MESSAGE='Reply with exactly: replay_gate_turn_2_ok'

usage() {
  cat <<'EOF'
Usage:
  scripts/verify-openclaw-replay.sh [options]

Options:
  --session-id <id>       Override generated session id
  --model <model>         Model route (default: openai/gpt-5.1-codex)
  --agent-name <name>     Agent name under ~/.openclaw/agents (default: main)
  --openclaw-home <path>  OpenClaw state root (default: ~/.openclaw)
  --openclaw-bin <path>   Explicit openclaw binary path
  --log-dir <path>        OpenClaw log directory (default: /tmp/openclaw)
  --skip-log-check        Skip log scan
  -h, --help              Show this help
EOF
}

log() {
  printf '[verify-openclaw-replay] %s\n' "$*"
}

warn() {
  printf '[verify-openclaw-replay] WARNING: %s\n' "$*" >&2
}

fail() {
  printf '[verify-openclaw-replay] ERROR: %s\n' "$*" >&2
  exit 1
}

resolve_openclaw_bin() {
  if [[ -n "$OPENCLAW_BIN" ]]; then
    [[ -x "$OPENCLAW_BIN" ]] || fail "--openclaw-bin is not executable: $OPENCLAW_BIN"
    return
  fi

  if command -v openclaw >/dev/null 2>&1; then
    OPENCLAW_BIN="$(command -v openclaw)"
    return
  fi

  shopt -s nullglob
  local nvm_bins=("$HOME"/.nvm/versions/node/*/bin/openclaw)
  shopt -u nullglob
  if [[ ${#nvm_bins[@]} -gt 0 ]]; then
    OPENCLAW_BIN="$(ls -t "${nvm_bins[@]}" 2>/dev/null | head -n 1)"
    return
  fi

  if [[ -x "/usr/local/bin/openclaw" ]]; then
    OPENCLAW_BIN="/usr/local/bin/openclaw"
    return
  fi
  if [[ -x "/opt/homebrew/bin/openclaw" ]]; then
    OPENCLAW_BIN="/opt/homebrew/bin/openclaw"
    return
  fi

  fail "Could not find openclaw binary. Use --openclaw-bin."
}

ensure_bin_dir_on_path() {
  local bin_dir
  bin_dir="$(cd "$(dirname "$OPENCLAW_BIN")" && pwd)"
  case ":$PATH:" in
    *":$bin_dir:"*) ;;
    *) PATH="$bin_dir:$PATH" ;;
  esac
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --session-id)
        [[ $# -ge 2 ]] || fail "--session-id requires a value"
        SESSION_ID="$2"
        shift 2
        ;;
      --model)
        [[ $# -ge 2 ]] || fail "--model requires a value"
        MODEL="$2"
        shift 2
        ;;
      --agent-name)
        [[ $# -ge 2 ]] || fail "--agent-name requires a value"
        AGENT_NAME="$2"
        shift 2
        ;;
      --openclaw-home)
        [[ $# -ge 2 ]] || fail "--openclaw-home requires a value"
        OPENCLAW_HOME="$2"
        shift 2
        ;;
      --openclaw-bin)
        [[ $# -ge 2 ]] || fail "--openclaw-bin requires a value"
        OPENCLAW_BIN="$2"
        shift 2
        ;;
      --log-dir)
        [[ $# -ge 2 ]] || fail "--log-dir requires a value"
        OPENCLAW_LOG_DIR="$2"
        shift 2
        ;;
      --skip-log-check)
        SKIP_LOG_CHECK=1
        shift
        ;;
      -h|--help)
        usage
        exit 0
        ;;
      *)
        fail "Unknown option: $1"
        ;;
    esac
  done
}

run_turn() {
  local turn_label="$1"
  local message="$2"
  local output_file="$3"

  if [[ "$SUPPORTS_MODEL_FLAG" -eq 1 ]]; then
    if ! "$OPENCLAW_BIN" agent --session-id "$SESSION_ID" --model "$MODEL" --message "$message" >"$output_file" 2>&1; then
      cat "$output_file" >&2
      fail "$turn_label failed with non-zero exit status."
    fi
  else
    if ! "$OPENCLAW_BIN" agent --session-id "$SESSION_ID" --message "$message" >"$output_file" 2>&1; then
      cat "$output_file" >&2
      fail "$turn_label failed with non-zero exit status."
    fi
  fi

  if rg -q 'provided without its required following item' "$output_file"; then
    cat "$output_file" >&2
    fail "$turn_label returned reasoning-pairing 400."
  fi
}

main() {
  parse_args "$@"
  resolve_openclaw_bin
  ensure_bin_dir_on_path

  if "$OPENCLAW_BIN" agent --help 2>/dev/null | rg -q -- '--model'; then
    SUPPORTS_MODEL_FLAG=1
  else
    SUPPORTS_MODEL_FLAG=0
  fi

  local tmp_dir
  tmp_dir="$(mktemp -d /tmp/openclaw-replay-verify.XXXXXX)"
  trap 'rm -rf "$tmp_dir"' EXIT

  local turn1_out="$tmp_dir/turn1.out"
  local turn2_out="$tmp_dir/turn2.out"

  log "Using openclaw binary: $OPENCLAW_BIN"
  log "Session id: $SESSION_ID"
  if [[ "$SUPPORTS_MODEL_FLAG" -eq 1 ]]; then
    log "Model: $MODEL"
  else
    log "Model flag unsupported by CLI; using configured runtime model."
  fi

  run_turn "turn1" "$TURN1_MESSAGE" "$turn1_out"
  run_turn "turn2" "$TURN2_MESSAGE" "$turn2_out"

  local session_file="$OPENCLAW_HOME/agents/$AGENT_NAME/sessions/$SESSION_ID.jsonl"
  local wait_count=0
  while [[ ! -f "$session_file" && "$wait_count" -lt 10 ]]; do
    sleep 1
    wait_count=$((wait_count + 1))
  done
  [[ -f "$session_file" ]] || fail "Session file not found: $session_file"

  if ! rg -q '"stopReason":"toolUse"' "$session_file"; then
    fail "No toolUse stopReason found. Turn 1 did not produce tool-use replay data."
  fi

  if ! rg -q 'call_[^"|[:space:]]+\|fc_[^"[:space:]]+' "$session_file"; then
    fail "No call|fc tool-call IDs found in session transcript."
  fi

  if rg -q '"(id|toolCallId)":"call_[^"|]*fc_[^"]*"' "$session_file"; then
    fail "Detected malformed call/fc IDs without pipe separator."
  fi

  if rg -q 'provided without its required following item' "$session_file"; then
    fail "Session transcript contains reasoning-pairing 400."
  fi

  if ! rg -q 'replay_gate_turn_2_ok' "$turn2_out" && ! rg -q 'replay_gate_turn_2_ok' "$session_file"; then
    fail "Turn 2 did not produce expected marker replay_gate_turn_2_ok."
  fi

  if [[ "$SKIP_LOG_CHECK" -eq 0 ]]; then
    if [[ -d "$OPENCLAW_LOG_DIR" ]]; then
      local scoped_log_lines
      scoped_log_lines="$(rg -n "$SESSION_ID" "$OPENCLAW_LOG_DIR"/openclaw-*.log 2>/dev/null || true)"
      if [[ -z "$scoped_log_lines" ]]; then
        warn "No log lines found for session id $SESSION_ID under $OPENCLAW_LOG_DIR."
      else
        if printf '%s\n' "$scoped_log_lines" | rg -q 'provided without its required following item|isError=true'; then
          fail "Log lines for this session indicate replay error."
        fi
      fi
    else
      warn "Log directory does not exist: $OPENCLAW_LOG_DIR"
    fi
  fi

  log "Replay verification passed."
  log "Session transcript: $session_file"
}

main "$@"

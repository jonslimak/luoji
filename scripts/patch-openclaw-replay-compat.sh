#!/usr/bin/env bash
set -euo pipefail

# Apply the OpenAI replay compatibility patch to affected OpenClaw builds.
# The patch removes OpenAI from sanitizeToolCallIds to preserve call|fc IDs.

UNPATCHED_RG='const\s+sanitizeToolCallIds\s*=\s*isGoogle\s*\|\|\s*isMistral\s*\|\|\s*isAnthropic\s*\|\|\s*isOpenAi\s*;'
PATCHED_RG='const\s+sanitizeToolCallIds\s*=\s*isGoogle\s*\|\|\s*isMistral\s*\|\|\s*isAnthropic\s*;'

AFFECTED_VERSIONS=("2026.2.15")
EXPECTED_PATCHED_COUNT_2026_2_15=5

OPENCLAW_ROOT="${OPENCLAW_ROOT:-}"
DRY_RUN=0
FORCE=0
RESTART_GATEWAY=0

usage() {
  cat <<'EOF'
Usage:
  scripts/patch-openclaw-replay-compat.sh [options]

Options:
  --openclaw-root <path>  Explicit OpenClaw package root
  --dry-run               Show what would change, do not edit files
  --force                 Apply patch even on non-affected versions
  --restart-gateway       Run "openclaw gateway restart" after patch
  -h, --help              Show this help
EOF
}

log() {
  printf '[patch-openclaw-replay-compat] %s\n' "$*"
}

fail() {
  printf '[patch-openclaw-replay-compat] ERROR: %s\n' "$*" >&2
  exit 1
}

count_nonempty_lines() {
  printf '%s\n' "${1:-}" | sed '/^[[:space:]]*$/d' | wc -l | tr -d ' '
}

is_affected_version() {
  local version="$1"
  local item
  for item in "${AFFECTED_VERSIONS[@]}"; do
    if [[ "$item" == "$version" ]]; then
      return 0
    fi
  done
  return 1
}

resolve_openclaw_root() {
  if [[ -n "$OPENCLAW_ROOT" ]]; then
    [[ -f "$OPENCLAW_ROOT/package.json" ]] || fail "Invalid --openclaw-root: $OPENCLAW_ROOT"
    return
  fi

  if command -v npm >/dev/null 2>&1; then
    local npm_root
    npm_root="$(npm root -g 2>/dev/null || true)"
    if [[ -n "$npm_root" && -f "$npm_root/openclaw/package.json" ]]; then
      OPENCLAW_ROOT="$npm_root/openclaw"
      return
    fi
  fi

  if command -v openclaw >/dev/null 2>&1; then
    local openclaw_bin
    local link_target
    local candidate
    openclaw_bin="$(command -v openclaw)"
    if [[ -L "$openclaw_bin" ]]; then
      link_target="$(readlink "$openclaw_bin" || true)"
      if [[ -n "$link_target" ]]; then
        candidate="$(
          cd "$(dirname "$openclaw_bin")" &&
          cd "$(dirname "$link_target")" &&
          pwd
        )"
        if [[ -f "$candidate/package.json" ]]; then
          OPENCLAW_ROOT="$candidate"
          return
        fi
      fi
    fi
  fi

  shopt -s nullglob
  local nvm_candidates=("$HOME"/.nvm/versions/node/*/lib/node_modules/openclaw)
  shopt -u nullglob
  if [[ ${#nvm_candidates[@]} -gt 0 ]]; then
    OPENCLAW_ROOT="$(ls -dt "${nvm_candidates[@]}" 2>/dev/null | head -n 1)"
    [[ -f "$OPENCLAW_ROOT/package.json" ]] && return
  fi

  if [[ -f "/usr/local/lib/node_modules/openclaw/package.json" ]]; then
    OPENCLAW_ROOT="/usr/local/lib/node_modules/openclaw"
    return
  fi
  if [[ -f "/opt/homebrew/lib/node_modules/openclaw/package.json" ]]; then
    OPENCLAW_ROOT="/opt/homebrew/lib/node_modules/openclaw"
    return
  fi

  fail "Could not locate OpenClaw install. Set OPENCLAW_ROOT or pass --openclaw-root."
}

resolve_openclaw_bin() {
  if command -v openclaw >/dev/null 2>&1; then
    command -v openclaw
    return
  fi

  local candidate="$OPENCLAW_ROOT/../../../bin/openclaw"
  if [[ -x "$candidate" ]]; then
    printf '%s\n' "$candidate"
    return
  fi

  printf '\n'
}

ensure_bin_dir_on_path() {
  local openclaw_bin="$1"
  local bin_dir
  bin_dir="$(cd "$(dirname "$openclaw_bin")" && pwd)"
  case ":$PATH:" in
    *":$bin_dir:"*) ;;
    *) PATH="$bin_dir:$PATH" ;;
  esac
}

parse_args() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --openclaw-root)
        [[ $# -ge 2 ]] || fail "--openclaw-root requires a value"
        OPENCLAW_ROOT="$2"
        shift 2
        ;;
      --dry-run)
        DRY_RUN=1
        shift
        ;;
      --force)
        FORCE=1
        shift
        ;;
      --restart-gateway)
        RESTART_GATEWAY=1
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

main() {
  parse_args "$@"
  resolve_openclaw_root

  local version
  version="$(sed -n 's/.*"version":[[:space:]]*"\([^"]*\)".*/\1/p' "$OPENCLAW_ROOT/package.json" | head -n 1)"
  [[ -n "$version" ]] || fail "Could not read OpenClaw version from $OPENCLAW_ROOT/package.json"

  log "OpenClaw root: $OPENCLAW_ROOT"
  log "Detected version: $version"

  if ! is_affected_version "$version" && [[ "$FORCE" -ne 1 ]]; then
    log "Version $version is not in affected list (${AFFECTED_VERSIONS[*]}). Skipping."
    exit 0
  fi

  local search_root="$OPENCLAW_ROOT/dist"
  [[ -d "$search_root" ]] || fail "Missing dist directory: $search_root"

  local candidate_files
  candidate_files="$(rg -l "$UNPATCHED_RG|$PATCHED_RG" "$search_root" 2>/dev/null | sort -u || true)"
  [[ -n "$candidate_files" ]] || fail "No sanitizeToolCallIds candidates found under $search_root"

  local patched_now=0
  local already_patched=0
  local needs_patch=0
  local file

  while IFS= read -r file; do
    [[ -n "$file" ]] || continue
    if rg -q "$UNPATCHED_RG" "$file"; then
      needs_patch=$((needs_patch + 1))
      if [[ "$DRY_RUN" -eq 1 ]]; then
        log "[dry-run] would patch $file"
        continue
      fi

      perl -0pi -e 's/const\s+sanitizeToolCallIds\s*=\s*isGoogle\s*\|\|\s*isMistral\s*\|\|\s*isAnthropic\s*\|\|\s*isOpenAi\s*;/const sanitizeToolCallIds = isGoogle || isMistral || isAnthropic;/g' "$file"

      if ! rg -q "$PATCHED_RG" "$file"; then
        fail "Patch verification failed in $file"
      fi
      if rg -q "$UNPATCHED_RG" "$file"; then
        fail "Unpatched OpenAI sanitize expression remains in $file"
      fi
      patched_now=$((patched_now + 1))
    elif rg -q "$PATCHED_RG" "$file"; then
      already_patched=$((already_patched + 1))
    fi
  done <<< "$candidate_files"

  local unpatched_files
  local patched_files
  local unpatched_count
  local patched_count
  unpatched_files="$(rg -l "$UNPATCHED_RG" "$search_root" 2>/dev/null | sort -u || true)"
  patched_files="$(rg -l "$PATCHED_RG" "$search_root" 2>/dev/null | sort -u || true)"
  unpatched_count="$(count_nonempty_lines "$unpatched_files")"
  patched_count="$(count_nonempty_lines "$patched_files")"

  if [[ "$DRY_RUN" -eq 1 ]]; then
    log "dry-run summary: needs_patch=$needs_patch already_patched=$already_patched"
    log "dry-run verification: currently patched_count=$patched_count unpatched_count=$unpatched_count"
    exit 0
  fi

  [[ "$unpatched_count" -eq 0 ]] || fail "Found $unpatched_count unpatched files after patch attempt."

  if [[ "$version" == "2026.2.15" ]]; then
    if [[ "$patched_count" -ne "$EXPECTED_PATCHED_COUNT_2026_2_15" ]]; then
      fail "Version $version expected $EXPECTED_PATCHED_COUNT_2026_2_15 patched files, found $patched_count."
    fi
  fi

  log "Patch complete: patched_now=$patched_now already_patched=$already_patched patched_count=$patched_count"

  if [[ "$RESTART_GATEWAY" -eq 1 ]]; then
    local openclaw_bin
    openclaw_bin="$(resolve_openclaw_bin)"
    if [[ -n "$openclaw_bin" ]]; then
      ensure_bin_dir_on_path "$openclaw_bin"
      log "Restarting gateway using $openclaw_bin"
      "$openclaw_bin" gateway restart
      log "Gateway restart complete."
    else
      fail "Requested --restart-gateway but openclaw binary was not found in PATH or near install root."
    fi
  fi
}

main "$@"

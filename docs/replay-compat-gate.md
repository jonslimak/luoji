# OpenClaw Replay Compatibility Gate

Last updated: 2026-02-17

## Purpose

Prevent recurrence of OpenAI replay failures:

- `400 Item 'rs_...' of type 'reasoning' was provided without its required following item.`

This gate is required for deployments and upgrades where OpenAI replay behavior can change.

## Scope

- OpenClaw installs using OpenAI Responses path
- Local hotfix compatibility on affected versions (currently `2026.2.15`)

## Gate Inputs

1. Patch automation
   - `scripts/patch-openclaw-replay-compat.sh`
2. Replay verification
   - `scripts/verify-openclaw-replay.sh`

## Required Release Gate Steps

1. Detect and patch affected OpenClaw install:

```bash
scripts/patch-openclaw-replay-compat.sh --restart-gateway
```

2. Run replay verification:

```bash
scripts/verify-openclaw-replay.sh
```

3. Block release if either script fails.

## Pass Criteria

All of the following must be true:

1. No remaining unpatched `sanitizeToolCallIds ... || isOpenAi` expression in targeted OpenClaw dist files.
2. Tool call IDs in replay transcript retain `call_*|fc_*` shape.
3. Two-turn replay smoke test succeeds.
4. No reasoning-pairing 400 in session transcript or scoped logs.

## Fail Handling

If gate fails:

1. Do not deploy/upgrade further.
2. Keep Anthropic lane as primary for production traffic.
3. Keep OpenAI lane as fallback/canary only.
4. Capture evidence in `progress.txt`:
   - OpenClaw version
   - failing session id
   - failing script output
   - rollback or mitigation action

## Rollback Guidance

If a new install or update breaks replay:

1. Restore previous known-good runtime/install state.
2. Re-apply patch script for affected versions.
3. Re-run replay verification.
4. Resume release only after full gate pass.

## Upstream Alignment

Long-term goal is to remove local patching once upstream behavior is fixed and verified.

Before removing local patch path:

1. Validate the same gate on the upstream fixed version without local edits.
2. Confirm repeated multi-turn OpenAI runs stay stable.
3. Update this document and `bug400fix.txt` to mark local patch path retired.

# OpenClaw Setup Tasks

Last updated: 2026-02-16
Status: Milestone 0 in progress

## Workflow Method (Cross-Machine)

1. GitHub repo `https://github.com/jonslimak/luoji` is the source of truth.
2. Target machine agent performs installation and configuration work.
3. Planning/review can happen on this machine, but status docs are updated in GitHub by the target machine workflow.
4. Target machine updates these files each milestone:
   - `plan.md`
   - `task.md`
   - `progress.txt`
5. Never commit secrets. Log only status/evidence and redact sensitive values.

## Priority Order

1. Milestone 0 - Repo and rollback baseline
2. Milestone 1 - Local secure vertical slice
3. Milestone 2 - Remote access via Tailscale Serve
4. Milestone 3 - Telegram channel flow
5. Milestone 4 - Model flexibility path
6. Milestone 5 - Operational hardening and updates

## Working Rules

1. Keep implementation simple.
2. Complete one milestone before expanding scope.
3. Use soft gate review at the end of each milestone.
4. Create a rollback point after each passed milestone.

## Milestone 0 Tasks: Repo and Rollback Baseline

- [x] M0-T1: Initialize local git repo (if missing) and connect to `https://github.com/jonslimak/luoji`.
- [x] M0-T2: Install Codex on the target machine and clone the same GitHub repo there.
- [x] M0-T3: Validate target machine can pull and push to origin.
- [x] M0-T4: Set default branch strategy and branch naming (`codex/<purpose>`).
- [x] M0-T5: Create release note template for milestone tags.
- [ ] M0-T6: Create baseline tag (`vYYYY.MM.DD-1`) before setup work.
- [ ] M0-T7: Run dry-run rollback command and confirm it works.

Verification:
- [x] M0-V1: `git remote -v` shows expected origin.
- [x] M0-V2: Target machine can push a non-secret docs update.
- [ ] M0-V3: Baseline tag exists in `git tag`.
- [ ] M0-V4: Rollback dry-run command is documented and tested.

Soft gate decision:
- [ ] M0-GATE: Proceed / Pause (case by case)

## Milestone 1 Tasks: Local Secure Vertical Slice

- [ ] M1-T1: Install OpenClaw via official installer.
- [ ] M1-T2: Run `openclaw onboard --install-daemon`.
- [ ] M1-T3: Confirm local mode and loopback bind.
- [ ] M1-T4: Confirm gateway auth token is enabled.
- [ ] M1-T5: Configure OpenAI provider and primary model.
- [ ] M1-T6: Open Control UI and run first successful chat.
- [ ] M1-T7: Run `openclaw doctor` and address blocking issues.

Verification:
- [ ] M1-V1: `openclaw gateway status` is healthy.
- [ ] M1-V2: `openclaw health` is healthy.
- [ ] M1-V3: `openclaw models status` confirms OpenAI auth.
- [ ] M1-V4: Control UI test message succeeds.

Soft gate decision:
- [ ] M1-GATE: Proceed / Pause (case by case)

Rollback point:
- [ ] M1-R1: Commit docs/changes (non-secret only).
- [ ] M1-R2: Create milestone tag and release note.

## Milestone 2 Tasks: Remote Access (Tailscale Serve)

- [ ] M2-T1: Install and authenticate Tailscale on Mac mini.
- [ ] M2-T2: Configure OpenClaw for Tailscale Serve mode.
- [ ] M2-T3: Confirm gateway remains loopback-bound.
- [ ] M2-T4: Validate remote Control UI from second tailnet device.
- [ ] M2-T5: Run security audit and fix critical findings.

Verification:
- [ ] M2-V1: Remote UI session works over tailnet.
- [ ] M2-V2: No direct LAN/public gateway exposure.
- [ ] M2-V3: `openclaw security audit` has no unresolved critical issues.

Soft gate decision:
- [ ] M2-GATE: Proceed / Pause (case by case)

Rollback point:
- [ ] M2-R1: Commit docs/changes (non-secret only).
- [ ] M2-R2: Create milestone tag and release note.

## Milestone 3 Tasks: Telegram Channel

- [ ] M3-T1: Create Telegram bot token in BotFather.
- [ ] M3-T2: Configure Telegram channel in OpenClaw.
- [ ] M3-T3: Keep `dmPolicy` as pairing.
- [ ] M3-T4: Keep group mention requirement enabled.
- [ ] M3-T5: Approve first pairing code.
- [ ] M3-T6: Validate DM and group mention behavior.

Verification:
- [ ] M3-V1: Pairing list and approve flow works.
- [ ] M3-V2: Approved DM user receives responses.
- [ ] M3-V3: Group replies follow mention rule as expected.
- [ ] M3-V4: Logs show no recurring delivery errors.

Soft gate decision:
- [ ] M3-GATE: Proceed / Pause (case by case)

Rollback point:
- [ ] M3-R1: Commit docs/changes (non-secret only).
- [ ] M3-R2: Create milestone tag and release note.

## Milestone 4 Tasks: Model Flexibility

- [ ] M4-T1: Confirm stable OpenAI primary model.
- [ ] M4-T2: Add fallback model configuration plan.
- [ ] M4-T3: Document provider switch procedure (OpenAI to Anthropic/others).
- [ ] M4-T4: Validate config with `openclaw models status`.

Verification:
- [ ] M4-V1: Current OpenAI model remains stable.
- [ ] M4-V2: Fallback config is valid and visible.
- [ ] M4-V3: Provider switch procedure is clear and testable.

Soft gate decision:
- [ ] M4-GATE: Proceed / Pause (case by case)

Rollback point:
- [ ] M4-R1: Commit docs/changes (non-secret only).
- [ ] M4-R2: Create milestone tag and release note.

## Milestone 5 Tasks: Operations and Update Cadence

- [ ] M5-T1: Define weekly maintenance checklist.
- [ ] M5-T2: Perform one controlled update cycle:
  pre-update tag -> update -> doctor -> restart -> health check -> post-update tag.
- [ ] M5-T3: Test rollback to previous milestone tag and confirm recovery.

Verification:
- [ ] M5-V1: Update cycle completed without regressions.
- [ ] M5-V2: Rollback test succeeded.
- [ ] M5-V3: Maintenance checklist is documented and usable.

Soft gate decision:
- [ ] M5-GATE: Proceed / Pause (case by case)

Rollback point:
- [ ] M5-R1: Commit docs/changes (non-secret only).
- [ ] M5-R2: Create milestone tag and release note.

## Common Mistake Prevention Checklist

- [ ] C1: Auth mismatch check completed (token/scope status confirmed).
- [ ] C2: Pairing and mention policy validated before deeper debugging.
- [ ] C3: Telegram privacy mode and numeric IDs validated.
- [ ] C4: `openclaw doctor` run after setup/config changes.
- [ ] C5: `openclaw security audit` run before remote/channel expansion.
- [ ] C6: Tag created for each accepted milestone.

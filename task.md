# OpenClaw Setup Tasks

Last updated: 2026-02-17
Status: Milestone 1 complete, Anthropic-primary validated; fallback/canary replay work paused (non-blocking)

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

## Immediate Priority Override (2026-02-17)

- [x] P0-T1: Switch runtime primary provider/model route to Anthropic.
- [x] P0-T2: Verify Anthropic auth and healthy model status.
- [x] P0-T3: Run consecutive-turn CLI/UI smoke tests on Anthropic-primary path.
- [x] P0-T4: Keep OpenAI enabled only as fallback/canary after Anthropic pass.

Verification:
- [x] P0-V1: `openclaw models status` shows Anthropic configured and primary route active.
- [x] P0-V2: Anthropic-primary consecutive-turn run succeeds without replay 400 issues.
- [x] P0-V3: OpenAI fallback remains documented and non-primary.

## Fallback/Canary Replay Work (Paused, Non-Blocking)

- [x] C0-T1: Add replay patch automation script (`scripts/patch-openclaw-replay-compat.sh`).
- [x] C0-T2: Add replay verification script (`scripts/verify-openclaw-replay.sh`).
- [x] C0-T3: Add replay gate documentation (`docs/replay-compat-gate.md`).
- [ ] C0-T4: Complete full fallback lane release-gate integration in deployment workflow.
- [ ] C0-T5: Run replay gate on a future OpenClaw upgrade candidate and record outcome.
- [ ] C0-T6: Decide keep/finish vs remove fallback canary workflow based on operational value.

Verification:
- [x] C0-V1: Replay fallback assets exist in repo and are documented.
- [ ] C0-V2: Replay gate proven in a full upgrade/deploy cycle.
- [x] C0-V3: Canary backlog does not block Anthropic-primary or Milestone 2 execution.

## Milestone 0 Tasks: Repo and Rollback Baseline

- [x] M0-T1: Initialize local git repo (if missing) and connect to `https://github.com/jonslimak/luoji`.
- [x] M0-T2: Install Codex on the target machine and clone the same GitHub repo there.
- [x] M0-T3: Validate target machine can pull and push to origin.
- [x] M0-T4: Set default branch strategy and branch naming (`codex/<purpose>`).
- [x] M0-T5: Create release note template for milestone tags.
- [x] M0-T6: Create baseline tag (`vYYYY.MM.DD-1`) before setup work.
- [x] M0-T7: Run dry-run rollback command and confirm it works.

Verification:
- [x] M0-V1: `git remote -v` shows expected origin.
- [x] M0-V2: Target machine can push a non-secret docs update.
- [x] M0-V3: Baseline tag exists in `git tag`.
- [x] M0-V4: Rollback dry-run command is documented and tested.

Soft gate decision:
- [x] M0-GATE: Proceed (validated on 2026-02-16)

## Milestone 1 Tasks: Local Secure Vertical Slice

- [x] M1-T1: Install OpenClaw via official installer.
- [x] M1-T2: Run `openclaw onboard --install-daemon`.
- [x] M1-T3: Confirm local mode and loopback bind.
- [x] M1-T4: Confirm gateway auth token is enabled.
- [x] M1-T5: Configure OpenAI provider and primary model.
- [x] M1-T6: Open Control UI and run first successful chat.
- [x] M1-T7: Run `openclaw doctor` and address blocking issues.

Verification:
- [x] M1-V1: `openclaw gateway status` is healthy.
- [x] M1-V2: `openclaw health` is healthy.
- [x] M1-V3: `openclaw models status` confirms OpenAI auth.
- [x] M1-V4: Control UI test message succeeds.

Soft gate decision:
- [x] M1-GATE: Proceed (validated on 2026-02-16)

Rollback point:
- [x] M1-R1: Commit docs/changes (non-secret only).
- [x] M1-R2: Create milestone tag and release note.

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

- [ ] M4-T1: Confirm stable Anthropic primary model.
- [ ] M4-T2: Add fallback model configuration plan.
- [ ] M4-T3: Document provider switch procedure (Anthropic to OpenAI/others).
- [ ] M4-T4: Validate config with `openclaw models status`.

Verification:
- [ ] M4-V1: Current Anthropic model remains stable.
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

## Session Handoff Notes (2026-02-16)

- Active implementation branch: `codex/m1-local-vertical-slice`
- Milestone tags:
  - `v2026.02.16-1` (Milestone 0 baseline)
  - `v2026.02.16-2` (Milestone 1 local secure vertical slice)
- Local runtime state:
  - Gateway: loopback `127.0.0.1:18789` with token auth
  - LaunchAgent: `ai.openclaw.gateway` loaded/running
  - Model: `anthropic/claude-sonnet-4-5` (primary), fallback `openai/gpt-5.1-codex`
- UI recovery actions completed:
  - Created `/Users/luo/.openclaw/workspace/MEMORY.md` to satisfy agent file reads.
  - Reset corrupted session key `agent:main:main` after OpenAI reasoning 400 errors.
  - Session backup path: `/Users/luo/.openclaw/agents/main/sessions/backups/20260216-155554`
- Known non-blocking warning:
  - Gateway service uses Node from `nvm`; migrate to system Node during hardening milestone.
- First command in next session:
  - `openclaw dashboard` and send one test message before Milestone 2 changes.

## Common Mistake Prevention Checklist

- [x] C1: Auth mismatch check completed (token/scope status confirmed).
- [ ] C2: Pairing and mention policy validated before deeper debugging.
- [ ] C3: Telegram privacy mode and numeric IDs validated.
- [x] C4: `openclaw doctor` run after setup/config changes.
- [ ] C5: `openclaw security audit` run before remote/channel expansion.
- [x] C6: Tag created for each accepted milestone.

# OpenClaw Mac Mini Setup Plan

Last updated: 2026-02-16

## Workflow Method (GitHub Source of Truth)

This project is planned on this machine, but installation work happens on a different target machine (the Mac mini).

Operational workflow:

1. GitHub repo is the source of truth: `https://github.com/jonslimak/luoji`.
2. The target machine runs Codex locally and executes install/config commands there.
3. The target machine agent updates `plan.md`, `task.md`, and `progress.txt` directly in the repo as milestones move forward.
4. This machine is used for planning, reviews, approvals, and tracking.
5. Every accepted milestone creates:
   - a commit (non-secret files only)
   - a milestone tag (`vYYYY.MM.DD-N`)
   - a short release/rollback note
6. Secrets never go to GitHub. Store tokens/keys only on the target machine and write `configured` in docs instead of secret values.

Commit guidance for the target machine agent:

1. Pull latest `main` before each work session.
2. Work in a `codex/<purpose>` branch when possible.
3. Keep commits small and milestone-aligned.
4. Push updates after verification evidence is captured.
5. Merge to `main` only after soft gate review.

## 1. Goal

Set up OpenClaw on a Mac mini with:

- A simple, reliable vertical slice first
- Strong safety defaults
- Remote access from day one (Tailscale Serve)
- Telegram as the first external channel
- OpenAI as the first model provider
- Built-in versioning and rollback points

## 2. Success Criteria

We consider this plan successful when all of the following are true:

1. Local Control UI works and can complete a test chat.
2. Remote Control UI works over tailnet.
3. Telegram pairing and message flow work end to end.
4. OpenAI model works and model switch path is documented.
5. Each completed milestone has a rollback point (tag + notes).

## 3. Principles

1. Simplicity first: one layer at a time.
2. Vertical slice first: get one useful flow working before expansion.
3. Safety before convenience: keep strict defaults, then relax only if needed.
4. Reversible progress: every milestone is easy to roll back.
5. Soft gates: use checklist evidence and decide case by case.

## 4. Scope and Defaults

- Install path: stable macOS app + external OpenClaw CLI
- Runtime profile: dedicated always-on service
- Execution model: Codex runs on target machine; GitHub carries shared plan/task/progress state
- Remote path: Tailscale Serve
- First channel: Telegram (plus Control UI)
- Model start: OpenAI
- Update policy: stable channel with controlled updates
- Versioning policy: milestone tags after tested checkpoints

## 5. Milestones

## Milestone 0: Repo and Rollback Baseline

Objective:
- Prepare Git workflow and rollback structure before system changes.

Implementation:
1. Connect local project to `https://github.com/jonslimak/luoji`.
2. Use branch pattern `codex/<purpose>`.
3. Define tag pattern `vYYYY.MM.DD-N`.
4. Add a release/rollback note template.
5. Set up target machine workflow (Codex installed there, repo cloned there).
6. Create baseline tag before setup work starts.

Soft gate checklist:
- Local repo is connected to GitHub and push works.
- Target machine can pull/push updates to the same repo.
- Baseline tag exists.
- Dry-run rollback command is validated.

## Milestone 1: Local Secure Vertical Slice

Objective:
- Local OpenClaw service is healthy and Control UI works with OpenAI.

Implementation:
1. Install OpenClaw via official installer.
2. Run onboarding wizard with daemon install.
3. Keep gateway bind on loopback.
4. Keep gateway auth token enabled.
5. Configure OpenAI key and primary model.
6. Verify with status, health, and dashboard.

Soft gate checklist:
- `openclaw gateway status` is healthy.
- Control UI opens and returns a valid response.
- `openclaw models status` confirms model auth.
- `openclaw doctor` shows no blocking issues.

## Milestone 2: Remote Access (Tailscale Serve)

Objective:
- Secure remote access works without exposing the gateway directly.

Implementation:
1. Enable Tailscale Serve mode.
2. Keep gateway bound to loopback.
3. Validate remote access from a second tailnet device.
4. Confirm auth behavior is still correct.

Soft gate checklist:
- Remote UI access works.
- No unintended LAN/public gateway exposure.
- `openclaw security audit` has no unresolved critical findings.

## Milestone 3: Telegram Channel

Objective:
- Telegram DM flow works safely and predictably.

Implementation:
1. Create bot token in BotFather.
2. Configure Telegram channel settings.
3. Keep `dmPolicy` on pairing.
4. Keep group mention requirement enabled initially.
5. Approve first pairing request and test round trip.

Soft gate checklist:
- Pairing flow succeeds.
- Approved DM user gets responses.
- Group mention behavior works as expected.
- Logs show no recurring message delivery errors.

## Milestone 4: Model Flexibility

Objective:
- Keep OpenAI primary now and maintain a clean switch path to Anthropic or others.

Implementation:
1. Keep OpenAI primary model stable.
2. Define fallback model strategy.
3. Add provider switch runbook (OpenAI to Anthropic or other).
4. Validate current config with `openclaw models status`.

Soft gate checklist:
- Current model remains stable.
- Fallback settings are valid and visible.
- Provider switch runbook is clear and testable.

## Milestone 5: Operational Hardening and Update Cadence

Objective:
- Keep system stable through controlled updates and repeatable checks.

Implementation:
1. Use stable channel updates only.
2. For each update: pre-update tag -> update -> doctor -> restart -> health check -> post-update tag.
3. Keep a short weekly maintenance checklist.

Soft gate checklist:
- One full update cycle is completed successfully.
- Rollback to prior milestone is demonstrated.

## 6. Common Friction and Planned Prevention

1. Gateway auth mismatches:
- Prevention: verify auth mode and token early using status and logs.

2. Pairing or mention rules mistaken for broken bot:
- Prevention: check pairing list and mention settings before deeper debugging.

3. Telegram online but no message flow:
- Prevention: verify pairing, bot privacy mode, and numeric IDs.

4. Onboarding skips model/auth:
- Prevention: always run `openclaw models status` before milestone closure.

5. Config validation failures:
- Prevention: use onboarding/config commands and run `openclaw doctor` after changes.

6. Upgrade regressions:
- Prevention: use milestone tags and controlled update runbook with rollback notes.

## 7. Versioning and Rollback Strategy

Every completed milestone includes:

1. A Git commit for tracked project docs and scripts (no secrets).
2. A Git tag (`vYYYY.MM.DD-N`).
3. A short release note with:
   - what changed
   - what was verified
   - known risks
   - rollback commands
4. A runtime snapshot note for local OpenClaw state path and timestamp.

Rollback model:

1. Code rollback:
- checkout prior tag and restore known-good repo state.

2. Runtime rollback:
- restore matching OpenClaw state snapshot for that same milestone.

## 8. Verification Approach

Core command ladder for each milestone:

1. `openclaw status`
2. `openclaw gateway status`
3. `openclaw logs --follow`
4. `openclaw doctor`
5. `openclaw channels status --probe` (when channels are enabled)

Evidence to capture:

- command output summary
- pass/fail result
- decision to proceed or pause

# Five-File Context Runbook

Last updated: 2026-02-17

## Purpose

Standardize OpenClaw persistent context with low overhead:

- Required files exist and are maintained:
  - `/Users/luo/.openclaw/workspace/SOUL.md`
  - `/Users/luo/.openclaw/workspace/IDENTITY.md`
  - `/Users/luo/.openclaw/workspace/USER.md`
  - `/Users/luo/.openclaw/workspace/TOOLS.md`
  - `/Users/luo/.openclaw/workspace/MEMORY.md`
- Startup stays lean and predictable.
- Daily and long-term memory workflow is explicit.

## Session Startup Policy (Lean)

At session start:

1. Read `SOUL.md`.
2. Read `USER.md`.
3. Read `memory/YYYY-MM-DD.md` for today and yesterday.
4. In main/direct session, also read `MEMORY.md`.
5. Read `IDENTITY.md` and `TOOLS.md` on demand when task scope requires persona, naming, device/tool details, or environment-specific command context.

## File Ownership and Use

- `SOUL.md`: operating style, boundaries, and behavioral guardrails.
- `IDENTITY.md`: assistant identity and naming details.
- `USER.md`: user profile and preferences.
- `TOOLS.md`: environment-specific command/tool notes.
- `MEMORY.md`: curated durable memory.
- `memory/YYYY-MM-DD.md`: daily operational log.

## Daily Log Workflow

Canonical location: `/Users/luo/.openclaw/workspace/memory/`

Daily file format:

- `Decisions`
- `Outcomes`
- `Blockers`
- `Lessons`

## Weekly Distillation Checklist

1. Review daily logs for the last 7 days.
2. Promote durable facts and repeated preferences to `MEMORY.md`.
3. Keep `MEMORY.md` concise and decision-oriented.
4. Do not delete historical daily logs during distillation.

## Backup and Restore

Before any structural cleanup changes:

1. Snapshot workspace markdown files, memory folder, sessions, logs, and sqlite memory.
2. Generate checksum manifest.
3. Verify required artifacts exist (`MEMORY.md`, `main.sqlite`, `sessions.json`, one or more `*.jsonl`).

Restore process:

1. Stop gateway interactions for the maintenance window.
2. Copy required files back from snapshot path.
3. Re-run a local smoke check (`openclaw gateway status`, one test message).

## QMD Scope Note

`memory-qmd-early-install` is tracked separately and is not required for five-file completion.

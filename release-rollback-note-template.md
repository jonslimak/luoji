# Release and Rollback Note Template

Last updated: 2026-02-16

## Milestone Metadata

- Milestone:
- Date (YYYY-MM-DD):
- Tag (`vYYYY.MM.DD-N`):
- Commit SHA:
- Machine:

## What Changed

1.
2.
3.

## What Was Verified

1. Command:
   - Result:
2. Command:
   - Result:
3. Command:
   - Result:

## Known Risks

1.
2.

## Rollback Commands

1. Code rollback:
   - `git fetch --tags`
   - `git checkout <tag>`
2. Runtime rollback:
   - Restore OpenClaw state snapshot captured for this milestone.
   - Snapshot path:
   - Snapshot timestamp:

## Secrets Check

- [ ] No secrets committed to GitHub
- [ ] Tokens/keys stored only on target machine
- [ ] Sensitive values redacted in notes/logs


# Clawbot Feature Catalog (Merged from 3 Articles)

## Scope
This catalog is derived only from the three articles shared in this chat.
Overlapping recommendations are merged into canonical feature blocks with source tags.

## Scoring Rubric
- `impact_score` (1-5): expected operational benefit if implemented.
- `effort_score` (1-5): estimated setup/maintenance complexity.
- `readiness`: `Now`, `Later`, or `Experimental`.
- `confidence`: `High`, `Medium`, or `Low` based on evidence strength in the articles.
- `status`: current implementation state from `progress.txt` and `task.md` (`Done`, `Partial`, `Not Started`, `Not Documented`).

## Quick Index

| feature_id | feature_name | category | impact | effort | readiness | confidence | status | source_articles |
| --- | --- | --- | --- | --- | --- | --- | --- | --- |
| foundation-local-always-on-host | Local Always-On Host | Foundation | 4 | 2 | Now | Medium | Done | Article 1 |
| billing-claude-membership-token | Claude Membership Token Routing | Foundation | 5 | 1 | Now | Medium | Not Documented | Article 1 |
| onboarding-preflight-keys | Preflight Accounts and Key Hygiene | Operations | 4 | 1 | Now | High | Not Documented | Article 1 |
| install-openclaw-core | OpenClaw Core Install and Bootstrap | Foundation | 5 | 2 | Now | High | Done | Article 1 |
| model-auth-anthropic-token-mode | Anthropic Token Mode Selection | Foundation | 5 | 1 | Now | High | Partial | Article 1 |
| channel-telegram-pairing | Telegram Bot Pairing Channel | Channels | 4 | 2 | Now | High | Not Started | Article 1 |
| integration-brave-search | Brave Search Integration | Skills | 3 | 1 | Now | Medium | Not Documented | Article 1 |
| integration-voice-transcription | Voice Note Transcription Path | Voice | 3 | 2 | Now | Medium | Not Documented | Article 1 |
| memory-qmd-early-install | Early QMD Install for Stability | Memory | 4 | 1 | Now | Low | Not Documented | Article 1 |
| memory-five-file-architecture | Five-File Context Architecture | Memory | 5 | 3 | Now | High | Done | Article 1, Article 2 |
| onboarding-context-interview | AI-Led Context Interview Bootstrap | Memory | 4 | 2 | Now | Medium | Not Documented | Article 1, Article 2 |
| tools-workaround-playbooks | TOOLS.md Workaround Playbooks | Skills | 5 | 3 | Now | High | Partial | Article 2 |
| memory-daily-log-distill | Daily Memory Logging and Distillation | Memory | 5 | 3 | Later | Medium | Partial | Article 2 |
| policy-correction-loop | AGENTS.md Correction Loop | Operations | 5 | 2 | Now | High | Not Documented | Article 2 |
| architecture-single-agent-skills | Single-Agent Skills-First Architecture | Operations | 4 | 2 | Now | Medium | Partial | Article 1, Article 2 |
| skills-modular-library | Modular Skill Library and Triggering | Skills | 4 | 3 | Later | Medium | Not Documented | Article 2 |
| ops-repo-hygiene | Repo Hygiene for Coding Sub-Agents | Operations | 3 | 1 | Now | High | Not Documented | Article 2 |
| ops-tmux-long-running | tmux for Long-Running Agents | Operations | 4 | 2 | Now | Medium | Not Documented | Article 2 |
| security-trust-boundaries | Trusted Channels and Security Rules | Security | 5 | 2 | Now | High | Partial | Article 2 |
| multimodal-ingestion-pipelines | Screenshot and Social Media Ingestion Pipelines | Skills | 4 | 4 | Later | Medium | Not Documented | Article 2 |
| voice-pineclaw-telephony | PineClaw Telephony Calls | Experimental | 4 | 3 | Experimental | Low | Not Documented | Article 3 |

## Feature Blocks

### Feature Block 01
- `feature_id`: `foundation-local-always-on-host`
- `feature_name`: Local Always-On Host
- `category`: `Foundation`
- `what_it_does`: Uses a low-cost always-on machine (for example Mac Mini or old laptop) as the dedicated OpenClaw host.
- `why_helpful`: Reduces cloud complexity and avoids overengineering early with remote infrastructure.
- `basic_setup_steps`:
1. Select an always-on machine with at least 2 GB RAM, 2 CPU cores, and 20 GB storage.
2. Keep power/network stable and place it where it can run continuously.
3. Reserve this machine as the primary host for one production agent profile.
- `configuration_recommendation`: Start local-first, single host, no remote orchestration until usage requires it.
- `dependencies`: Physical machine, stable internet, power uptime.
- `impact_score`: `4`
- `effort_score`: `2`
- `confidence`: `Medium`
- `readiness`: `Now`
- `source_articles`: `Article 1`
- `notes_and_risks`: Hardware failures or power interruptions can stop agent availability.
- `status`: `Done`
- `notes`: Documented on target Mac mini setup path; see `/Users/luo/Projects/luoji/progress.txt:12` and `/Users/luo/Projects/luoji/progress.txt:60`.

### Feature Block 02
- `feature_id`: `billing-claude-membership-token`
- `feature_name`: Claude Membership Token Routing
- `category`: `Foundation`
- `what_it_does`: Uses a Claude account token path rather than pay-per-use API console billing path.
- `why_helpful`: Intended to improve cost predictability and avoid runaway token spend in early experimentation.
- `basic_setup_steps`:
1. Choose a Claude plan level aligned to expected usage.
2. Install Claude CLI.
3. Run `claude setup-token` and store token securely.
4. Validate token formatting before onboarding.
- `configuration_recommendation`: Use one primary token source and avoid mixed billing models in initial rollout.
- `dependencies`: Claude account and CLI access.
- `impact_score`: `5`
- `effort_score`: `1`
- `confidence`: `Medium`
- `readiness`: `Now`
- `source_articles`: `Article 1`
- `notes_and_risks`: Cost claims are anecdotal in the source and may vary by usage pattern and provider changes.
- `status`: `Not Documented`
- `notes`: No explicit Claude membership-token workflow is tracked in status docs; current model/auth notes center on Anthropic API key and OpenAI fallback at `/Users/luo/Projects/luoji/progress.txt:247` and `/Users/luo/Projects/luoji/progress.txt:253`.

### Feature Block 03
- `feature_id`: `onboarding-preflight-keys`
- `feature_name`: Preflight Accounts and Key Hygiene
- `category`: `Operations`
- `what_it_does`: Standardizes pre-onboarding prep for required accounts and tokens before terminal setup begins.
- `why_helpful`: Prevents setup stalls and configuration mistakes caused by missing credentials or malformed tokens.
- `basic_setup_steps`:
1. Collect all required accounts: Claude, Telegram BotFather, Brave Search API, and optional Groq.
2. Store keys in one temporary secure staging location.
3. Validate each key format and remove trailing whitespace.
4. Keep a checklist and mark each key as tested once.
- `configuration_recommendation`: Treat key readiness as a hard gate before OpenClaw onboarding.
- `dependencies`: Account registrations, secure key storage workflow.
- `impact_score`: `4`
- `effort_score`: `1`
- `confidence`: `High`
- `readiness`: `Now`
- `source_articles`: `Article 1`
- `notes_and_risks`: Avoid sharing keys in plain chat logs or group channels.
- `status`: `Not Documented`
- `notes`: Preflight checklist for Claude/Brave/Groq/Telegram keys is not explicitly recorded in `/Users/luo/Projects/luoji/progress.txt` or `/Users/luo/Projects/luoji/task.md`.

### Feature Block 04
- `feature_id`: `install-openclaw-core`
- `feature_name`: OpenClaw Core Install and Bootstrap
- `category`: `Foundation`
- `what_it_does`: Establishes the minimum runtime stack (Node + OpenClaw CLI) and runs onboarding to first hatch.
- `why_helpful`: Creates a reproducible baseline so future features are additive, not blocked by install drift.
- `basic_setup_steps`:
1. Install Node runtime and verify available `npm`.
2. Install OpenClaw globally with `npm install -g openclaw`.
3. Run onboarding flow and accept baseline defaults.
4. Skip nonessential starter skills during bootstrap.
5. Enable all required startup hooks during onboarding.
- `configuration_recommendation`: Keep bootstrap lean and postpone noncritical integrations until baseline is stable.
- `dependencies`: Node runtime, npm, OpenClaw package access.
- `impact_score`: `5`
- `effort_score`: `2`
- `confidence`: `High`
- `readiness`: `Now`
- `source_articles`: `Article 1`
- `notes_and_risks`: Version-specific onboarding options may change over time.
- `status`: `Done`
- `notes`: Installation and onboarding are complete (`/Users/luo/Projects/luoji/task.md:80`, `/Users/luo/Projects/luoji/task.md:81`, `/Users/luo/Projects/luoji/progress.txt:63`, `/Users/luo/Projects/luoji/progress.txt:65`).

### Feature Block 05
- `feature_id`: `model-auth-anthropic-token-mode`
- `feature_name`: Anthropic Token Mode Selection
- `category`: `Foundation`
- `what_it_does`: Forces model setup through Anthropic token mode instead of API-key mode in onboarding.
- `why_helpful`: Reduces auth misconfiguration risk and aligns runtime with the selected billing/token strategy.
- `basic_setup_steps`:
1. In model provider selection, choose Anthropic.
2. Select token-based auth option.
3. Paste validated Claude token.
4. Retry onboarding if HTTPS/auth errors appear.
- `configuration_recommendation`: Enforce one provider auth path per environment and document it explicitly.
- `dependencies`: Valid Claude token and onboarding access.
- `impact_score`: `5`
- `effort_score`: `1`
- `confidence`: `High`
- `readiness`: `Now`
- `source_articles`: `Article 1`
- `notes_and_risks`: Mis-copied tokens (trailing spaces) can look like networking issues.
- `status`: `Partial`
- `notes`: Anthropic-primary route is validated, but docs show Anthropic API key addition instead of explicit token-mode onboarding (`/Users/luo/Projects/luoji/task.md:35`, `/Users/luo/Projects/luoji/task.md:41`, `/Users/luo/Projects/luoji/progress.txt:247` to `/Users/luo/Projects/luoji/progress.txt:254`).

### Feature Block 06
- `feature_id`: `channel-telegram-pairing`
- `feature_name`: Telegram Bot Pairing Channel
- `category`: `Channels`
- `what_it_does`: Connects the agent to Telegram via BotFather token and pairing-key exchange from TUI.
- `why_helpful`: Enables mobile-first conversations with a low-friction user channel.
- `basic_setup_steps`:
1. Create bot via `@BotFather` using `/newbot`.
2. Copy bot token into OpenClaw channel setup.
3. Hatch in TUI and receive pairing key.
4. Complete pairing from Telegram chat.
- `configuration_recommendation`: Use one production Telegram bot per primary agent identity.
- `dependencies`: Telegram account, BotFather token, OpenClaw pairing flow.
- `impact_score`: `4`
- `effort_score`: `2`
- `confidence`: `High`
- `readiness`: `Now`
- `source_articles`: `Article 1`
- `notes_and_risks`: Group/chat permissions should be reviewed before enabling broad channel access.
- `status`: `Not Started`
- `notes`: Telegram milestone tasks are still unchecked (`/Users/luo/Projects/luoji/task.md:121` to `/Users/luo/Projects/luoji/task.md:134`).

### Feature Block 07
- `feature_id`: `integration-brave-search`
- `feature_name`: Brave Search Integration
- `category`: `Skills`
- `what_it_does`: Adds web search capability by supplying a Brave Search API key to the agent.
- `why_helpful`: Improves answer freshness and allows external information retrieval in workflows.
- `basic_setup_steps`:
1. Create Brave Search API key.
2. Pass key to agent during post-hatch setup.
3. Run a known web lookup task to validate routing.
- `configuration_recommendation`: Start with read-only search usage and add query guardrails in instructions.
- `dependencies`: Brave API account and key management.
- `impact_score`: `3`
- `effort_score`: `1`
- `confidence`: `Medium`
- `readiness`: `Now`
- `source_articles`: `Article 1`
- `notes_and_risks`: Search quality and API quota behavior depend on provider limits.
- `status`: `Not Documented`
- `notes`: No Brave Search setup evidence appears in `/Users/luo/Projects/luoji/progress.txt` or `/Users/luo/Projects/luoji/task.md`.

### Feature Block 08
- `feature_id`: `integration-voice-transcription`
- `feature_name`: Voice Note Transcription Path
- `category`: `Voice`
- `what_it_does`: Enables voice-message ingestion through Groq transcription or native channel support when available.
- `why_helpful`: Increases real-world usage by enabling faster mobile interactions than typing.
- `basic_setup_steps`:
1. Decide channel path: native voice support or Groq integration.
2. If Groq is needed, add API key during setup.
3. Send test voice memo and validate transcript quality.
4. Tune prompt instructions for voice-first conversations.
- `configuration_recommendation`: Prefer native channel voice support first, use Groq as fallback.
- `dependencies`: Voice-capable channel, optional Groq API key.
- `impact_score`: `3`
- `effort_score`: `2`
- `confidence`: `Medium`
- `readiness`: `Now`
- `source_articles`: `Article 1`
- `notes_and_risks`: Channel capabilities may have changed since publication.
- `status`: `Not Documented`
- `notes`: No Groq/native voice transcription setup is recorded in `/Users/luo/Projects/luoji/progress.txt` or `/Users/luo/Projects/luoji/task.md`.

### Feature Block 09
- `feature_id`: `memory-qmd-early-install`
- `feature_name`: Early QMD Install for Stability
- `category`: `Memory`
- `what_it_does`: Installs QMD early in lifecycle before heavy conversation load.
- `why_helpful`: Aims to reduce reset/forgetfulness behavior reported when installed late.
- `basic_setup_steps`:
1. Install QMD immediately after core onboarding.
2. Validate by running short and then long conversation test.
3. Confirm memory/log persistence behavior before production usage.
- `configuration_recommendation`: Make QMD install part of baseline checklist before first real task load.
- `dependencies`: QMD skill/package availability.
- `impact_score`: `4`
- `effort_score`: `1`
- `confidence`: `Low`
- `readiness`: `Now`
- `source_articles`: `Article 1`
- `notes_and_risks`: Evidence is anecdotal from one operator report.
- `status`: `Not Documented`
- `notes`: No QMD installation evidence appears in `/Users/luo/Projects/luoji/progress.txt` or `/Users/luo/Projects/luoji/task.md`.

### Feature Block 10
- `feature_id`: `memory-five-file-architecture`
- `feature_name`: Five-File Context Architecture
- `category`: `Memory`
- `what_it_does`: Formalizes persistent context using `SOUL.md`, `IDENTITY.md`, `USER.md`, `TOOLS.md`, and `MEMORY.md` with lean startup loading and on-demand detail files.
- `why_helpful`: Converts session amnesia into repeatable operational context loaded every session.
- `basic_setup_steps`:
1. Create all five files with initial content.
2. Define personality, role, user profile, tool access, and current memory.
3. Ensure startup instructions load these files at session start.
4. Review and refresh files weekly.
- `configuration_recommendation`: Treat these files as required config, not optional docs.
- `dependencies`: OpenClaw workspace with editable markdown config files.
- `impact_score`: `5`
- `effort_score`: `3`
- `confidence`: `High`
- `readiness`: `Now`
- `source_articles`: `Article 1`, `Article 2`
- `notes_and_risks`: Memory files may contain sensitive operational details and must be access-scoped.
- `status`: `Done`
- `notes`: All five files exist in `/Users/luo/.openclaw/workspace`, runtime session metadata shows injection coverage for all five context files (`/Users/luo/.openclaw/agents/main/sessions/sessions.json:104` to `/Users/luo/.openclaw/agents/main/sessions/sessions.json:168`), and lean startup + weekly distillation process is documented in `/Users/luo/Projects/luoji/docs/five-file-context-runbook.md`.

### Feature Block 11
- `feature_id`: `onboarding-context-interview`
- `feature_name`: AI-Led Context Interview Bootstrap
- `category`: `Memory`
- `what_it_does`: Uses a structured interview prompt to elicit user preferences and auto-populate core context files.
- `why_helpful`: Produces higher-quality initial context than ad hoc manual writing and speeds onboarding.
- `basic_setup_steps`:
1. Run one-question-at-a-time interview prompt.
2. Capture work role, goals, communication style, and constraints.
3. Generate starter `SOUL.md` and `USER.md` (optionally all five files).
4. Review and edit for specificity.
- `configuration_recommendation`: Run this process immediately after first channel pairing.
- `dependencies`: Working chat channel and agent writing permissions.
- `impact_score`: `4`
- `effort_score`: `2`
- `confidence`: `Medium`
- `readiness`: `Now`
- `source_articles`: `Article 1`, `Article 2`
- `notes_and_risks`: Generated profiles require manual review to avoid overbroad instructions.
- `status`: `Not Documented`
- `notes`: No AI-led context interview bootstrap is documented in `/Users/luo/Projects/luoji/progress.txt` or `/Users/luo/Projects/luoji/task.md`.

### Feature Block 12
- `feature_id`: `tools-workaround-playbooks`
- `feature_name`: TOOLS.md Workaround Playbooks
- `category`: `Skills`
- `what_it_does`: Stores explicit execution playbooks and fallback syntax for known tool limitations.
- `why_helpful`: Reduces repeated failures where agents retry known-broken methods instead of proven workflows.
- `basic_setup_steps`:
1. List all available tools/APIs and credentials location rules.
2. Document known failure modes and exact workaround commands.
3. Add a rule to check `TOOLS.md` before declaring inability.
4. Update after each newly solved integration issue.
- `configuration_recommendation`: Keep workaround entries command-precise and task-scoped.
- `dependencies`: Tool inventory, API credentials, shell command availability.
- `impact_score`: `5`
- `effort_score`: `3`
- `confidence`: `High`
- `readiness`: `Now`
- `source_articles`: `Article 2`
- `notes_and_risks`: Command workflows may drift as provider APIs or CLIs change.
- `status`: `Partial`
- `notes`: Replay compatibility scripts and gate docs are implemented, but a broad `TOOLS.md` workaround system is not explicitly documented (`/Users/luo/Projects/luoji/progress.txt:206` to `/Users/luo/Projects/luoji/progress.txt:225`, `/Users/luo/Projects/luoji/task.md:47` to `/Users/luo/Projects/luoji/task.md:49`).

### Feature Block 13
- `feature_id`: `memory-daily-log-distill`
- `feature_name`: Daily Memory Logging and Distillation
- `category`: `Memory`
- `what_it_does`: Maintains daily operational notes and periodically distills durable facts into `MEMORY.md`.
- `why_helpful`: Builds institutional memory and reduces repeated context rebuilding across sessions.
- `basic_setup_steps`:
1. Create a daily notes folder structure.
2. Log decisions, outcomes, blockers, and lessons each day.
3. Schedule periodic distillation into `MEMORY.md`.
4. Prune stale details while preserving durable decisions.
- `configuration_recommendation`: Distill at least weekly; keep `MEMORY.md` concise and decision-oriented.
- `dependencies`: Memory folder conventions, write access to memory files.
- `impact_score`: `5`
- `effort_score`: `3`
- `confidence`: `Medium`
- `readiness`: `Later`
- `source_articles`: `Article 2`
- `notes_and_risks`: Overly verbose memory files can degrade retrieval quality.
- `status`: `Partial`
- `notes`: Canonical daily log path and weekly distillation checklist are now documented (`/Users/luo/Projects/luoji/docs/five-file-context-runbook.md`), and daily log scaffolding is recorded in `/Users/luo/Projects/luoji/progress.txt`; sustained weekly execution evidence is still pending.

### Feature Block 14
- `feature_id`: `policy-correction-loop`
- `feature_name`: AGENTS.md Correction Loop
- `category`: `Operations`
- `what_it_does`: Converts repeated mistakes into durable operating rules in `AGENTS.md`.
- `why_helpful`: Improves agent behavior continuously and reduces repeated rework across sessions.
- `basic_setup_steps`:
1. Add a section in `AGENTS.md` for correction rules.
2. Each time a repeatable mistake occurs, record the rule and expected behavior.
3. Include concrete examples and forbidden patterns.
4. Review recurring incidents weekly for new policy entries.
- `configuration_recommendation`: Require rule updates for any issue observed at least twice.
- `dependencies`: Editable `AGENTS.md` and operational review cadence.
- `impact_score`: `5`
- `effort_score`: `2`
- `confidence`: `High`
- `readiness`: `Now`
- `source_articles`: `Article 2`
- `notes_and_risks`: Overly rigid rules can block valid edge-case behavior if not maintained.
- `status`: `Not Documented`
- `notes`: No explicit AGENTS.md correction-loop implementation is tracked in `/Users/luo/Projects/luoji/progress.txt` or `/Users/luo/Projects/luoji/task.md`.

### Feature Block 15
- `feature_id`: `architecture-single-agent-skills`
- `feature_name`: Single-Agent Skills-First Architecture
- `category`: `Operations`
- `what_it_does`: Prioritizes one well-configured agent with modular skills over multi-agent sprawl.
- `why_helpful`: Reduces context fragmentation, costs, and coordination overhead.
- `basic_setup_steps`:
1. Choose one primary agent identity and channel.
2. Defer secondary agents unless a clear functional boundary exists.
3. Add needed capabilities through skills and tool playbooks.
4. Reassess only when one agent becomes a measurable bottleneck.
- `configuration_recommendation`: Default to one production agent plus optional short-lived task sub-agents.
- `dependencies`: Stable core profile, skills framework.
- `impact_score`: `4`
- `effort_score`: `2`
- `confidence`: `Medium`
- `readiness`: `Now`
- `source_articles`: `Article 1`, `Article 2`
- `notes_and_risks`: Some specialized workflows may still benefit from bounded multi-agent decomposition.
- `status`: `Partial`
- `notes`: Runtime appears focused on one main agent and staged fallback/canary lane, but no explicit skills-first architecture implementation is documented (`/Users/luo/Projects/luoji/task.md:188` to `/Users/luo/Projects/luoji/task.md:190`, `/Users/luo/Projects/luoji/progress.txt:231` to `/Users/luo/Projects/luoji/progress.txt:233`).

### Feature Block 16
- `feature_id`: `skills-modular-library`
- `feature_name`: Modular Skill Library and Triggering
- `category`: `Skills`
- `what_it_does`: Organizes domain skills as reusable markdown playbooks loaded only when relevant.
- `why_helpful`: Expands capability without bloating base prompts or forcing all instructions into one context.
- `basic_setup_steps`:
1. Define skill folders by function (for example copywriting, email, SEO, humanizer).
2. Write clear trigger conditions and execution checklists per skill.
3. Validate skill loading behavior with representative tasks.
4. Version and prune unused skills.
- `configuration_recommendation`: Keep skills narrow and composable; avoid monolithic general-purpose skills.
- `dependencies`: Skills directory conventions and loader support.
- `impact_score`: `4`
- `effort_score`: `3`
- `confidence`: `Medium`
- `readiness`: `Later`
- `source_articles`: `Article 2`
- `notes_and_risks`: Poorly scoped skill triggers can cause wrong skill activation.
- `status`: `Not Documented`
- `notes`: No modular skills library rollout is explicitly tracked in `/Users/luo/Projects/luoji/progress.txt` or `/Users/luo/Projects/luoji/task.md`.

### Feature Block 17
- `feature_id`: `ops-repo-hygiene`
- `feature_name`: Repo Hygiene for Coding Sub-Agents
- `category`: `Operations`
- `what_it_does`: Enforces clone location and cleanup policies for temporary coding tasks.
- `why_helpful`: Prevents workspace clutter and stale checkout confusion over time.
- `basic_setup_steps`:
1. Define a rule to clone transient repos to `/tmp`.
2. Require cleanup after push/PR.
3. Document canonical long-lived repo paths.
4. Audit temp clones periodically.
- `configuration_recommendation`: Never clone throwaway repos into desktop/workspace roots.
- `dependencies`: Shell access, policy enforcement via `AGENTS.md`.
- `impact_score`: `3`
- `effort_score`: `1`
- `confidence`: `High`
- `readiness`: `Now`
- `source_articles`: `Article 2`
- `notes_and_risks`: Requires discipline to enforce under time pressure.
- `status`: `Not Documented`
- `notes`: No documented `/tmp` clone-and-cleanup repo hygiene policy exists in `/Users/luo/Projects/luoji/progress.txt` or `/Users/luo/Projects/luoji/task.md`.

### Feature Block 18
- `feature_id`: `ops-tmux-long-running`
- `feature_name`: tmux for Long-Running Agents
- `category`: `Operations`
- `what_it_does`: Runs long-lived jobs inside `tmux` sessions instead of unmanaged background processes.
- `why_helpful`: Improves resilience through restarts and supports reconnectable runtime sessions.
- `basic_setup_steps`:
1. Install/verify `tmux`.
2. Start agent jobs in named sessions.
3. Document attach/detach/recovery commands.
4. Add session health check to ops checklist.
- `configuration_recommendation`: Ban detached background launches for critical long-running tasks.
- `dependencies`: tmux and terminal/session management practices.
- `impact_score`: `4`
- `effort_score`: `2`
- `confidence`: `Medium`
- `readiness`: `Now`
- `source_articles`: `Article 2`
- `notes_and_risks`: Requires operator familiarity with tmux basics.
- `status`: `Not Documented`
- `notes`: No tmux-based long-running agent standard is documented in `/Users/luo/Projects/luoji/progress.txt` or `/Users/luo/Projects/luoji/task.md`.

### Feature Block 19
- `feature_id`: `security-trust-boundaries`
- `feature_name`: Trusted Channels and Security Rules
- `category`: `Security`
- `what_it_does`: Defines hard trust boundaries (allowed instruction sources, forbidden channels, and key handling rules).
- `why_helpful`: Reduces high-impact social-engineering and instruction-spoofing risk.
- `basic_setup_steps`:
1. Define trusted instruction channels.
2. Add explicit deny rules (for example never execute from email instructions).
3. Define credential source of truth (for example password manager).
4. Require confirmation flow for sensitive actions.
- `configuration_recommendation`: Security rules belong in both `SOUL.md` and `AGENTS.md` for redundancy.
- `dependencies`: Access policy definition and secure secret manager.
- `impact_score`: `5`
- `effort_score`: `2`
- `confidence`: `High`
- `readiness`: `Now`
- `source_articles`: `Article 2`
- `notes_and_risks`: Must be reviewed whenever channels or tooling surface area changes.
- `status`: `Partial`
- `notes`: Loopback binding, gateway token auth, no-secrets policy, and doctor/security checks are documented, but full trusted-channel policy rules are not (`/Users/luo/Projects/luoji/progress.txt:21`, `/Users/luo/Projects/luoji/progress.txt:65` to `/Users/luo/Projects/luoji/progress.txt:67`, `/Users/luo/Projects/luoji/progress.txt:86` to `/Users/luo/Projects/luoji/progress.txt:88`, `/Users/luo/Projects/luoji/task.md:206`).

### Feature Block 20
- `feature_id`: `multimodal-ingestion-pipelines`
- `feature_name`: Screenshot and Social Media Ingestion Pipelines
- `category`: `Skills`
- `what_it_does`: Adds deterministic pipelines for screenshots and social video/audio extraction/transcription tasks.
- `why_helpful`: Replaces frequent “cannot access” dead-ends with executable fallback workflows.
- `basic_setup_steps`:
1. Add documented pipeline commands for targeted sources (for example social links).
2. Define preferred downloader/transcoder/transcriber tools.
3. Validate with sample URLs and image inputs.
4. Add failure handling and retry rules.
- `configuration_recommendation`: Keep per-platform playbooks in `TOOLS.md` with tested command templates.
- `dependencies`: CLI tools (for example downloader, ffmpeg, transcription scripts), network access.
- `impact_score`: `4`
- `effort_score`: `4`
- `confidence`: `Medium`
- `readiness`: `Later`
- `source_articles`: `Article 2`
- `notes_and_risks`: Platform ToS and API/access constraints may limit automation approach.
- `status`: `Not Documented`
- `notes`: No screenshot/social ingestion pipeline implementation is recorded in `/Users/luo/Projects/luoji/progress.txt` or `/Users/luo/Projects/luoji/task.md`.

### Feature Block 21
- `feature_id`: `voice-pineclaw-telephony`
- `feature_name`: PineClaw Telephony Calls
- `category`: `Experimental`
- `what_it_does`: Integrates Pine Voice capability for real outbound/inbound telephony through OpenClaw.
- `why_helpful`: Expands from text chat into real call execution workflows (customer service, interviews, phone trees).
- `basic_setup_steps`:
1. Register with Pine AI.
2. Install Pine Voice integration from OpenClaw ecosystem.
3. Configure call routing and identity settings.
4. Run constrained pilot calls with monitoring.
- `configuration_recommendation`: Pilot in sandbox or low-risk workflows before production usage.
- `dependencies`: Pine AI account, OpenClaw integration availability, telephony policy compliance.
- `impact_score`: `4`
- `effort_score`: `3`
- `confidence`: `Low`
- `readiness`: `Experimental`
- `source_articles`: `Article 3`
- `notes_and_risks`: Claim is based on a social post dated February 16, 2026 and should be verified before commitment.
- `status`: `Not Documented`
- `notes`: No PineClaw telephony integration work is tracked in `/Users/luo/Projects/luoji/progress.txt` or `/Users/luo/Projects/luoji/task.md`.

## Selection Worksheet
Use this worksheet to choose implementation order.

1. Create candidate shortlist: all `Now` features with `impact_score >= 4`.
2. Remove any feature blocked by missing dependencies.
3. Rank by this priority formula:
`priority = (impact_score * 2) - effort_score`
4. Break ties by:
`confidence` High > Medium > Low.
5. Final safety gate:
Any feature touching external channels, credentials, or telephony needs security review first.

## Suggested Initial Implementation Batch (from this catalog)
1. `onboarding-preflight-keys`
2. `install-openclaw-core`
3. `model-auth-anthropic-token-mode`
4. `memory-five-file-architecture`
5. `policy-correction-loop`
6. `security-trust-boundaries`
7. `channel-telegram-pairing`
8. `architecture-single-agent-skills`

---

# Planning Appendix (Original Plan)

## Summary
Create a single, clean feature catalog from the 3 provided articles and store it at `/Users/luo/Projects/luoji/docs/clawbot-feature-catalog.md`.
The catalog will use one canonical block per feature, include source tags, and add confidence/risk notes so future implementation choices are fast and low-ambiguity.

## Locked Decisions
- Merge overlapping recommendations into one canonical feature with source attribution.
- Deliver as a Markdown repo document first.
- Include confidence/risk notes.
- Include prioritization metadata: impact, effort, dependencies.

## Public Interface / Type Definition
Define and use this `FeatureBlock v1` schema for every catalog entry:

- `feature_id`: short stable id (e.g., `memory-core-files`)
- `feature_name`: human-readable title
- `category`: one of `Foundation`, `Memory`, `Channels`, `Voice`, `Skills`, `Operations`, `Security`, `Experimental`
- `what_it_does`: 1-3 sentences
- `why_helpful`: 1-3 sentences
- `basic_setup_steps`: 3-6 ordered steps
- `configuration_recommendation`: concrete defaults and constraints
- `dependencies`: required accounts/tools/files
- `impact_score`: integer 1-5
- `effort_score`: integer 1-5
- `confidence`: `High` | `Medium` | `Low`
- `readiness`: `Now` | `Later` | `Experimental`
- `source_articles`: list of `Article 1`, `Article 2`, `Article 3`
- `notes_and_risks`: caveats, security/privacy concerns, version sensitivity
- `status`: current implementation state from status docs
- `notes`: implementation notes with evidence references

## Implementation Plan
1. Extract all actionable recommendations from the 3 articles into a raw candidate list.
2. Split combined advice into atomic features (one feature = one independently buildable capability).
3. Merge duplicates and near-duplicates across articles into canonical features.
4. Resolve overlaps by preserving one feature and adding all supporting source tags.
5. Classify each feature into one category and assign readiness.
6. Fill each `FeatureBlock v1` field, including setup steps and concrete configuration defaults.
7. Score each feature with `impact_score` and `effort_score` using a fixed rubric in the doc.
8. Assign confidence levels based on evidence strength:
- High: repeated, concrete, stable guidance.
- Medium: concrete but partially anecdotal or version-sensitive.
- Low: very new claim, external dependency, or unverified ecosystem change.
9. Build final document structure:
- Title and scope note.
- Quick index table (feature id, name, category, impact, effort, readiness, confidence).
- Full detailed feature blocks.
- “Deferred/Experimental” section for uncertain items (for example PineClaw telephony).
10. Add a final “Selection Worksheet” section with shortlist prompts for future implementation decisions.

## Test Cases and Validation Scenarios
1. Completeness test: every meaningful recommendation from each article appears in a feature block or is explicitly excluded with reason.
2. Uniqueness test: no duplicated features with different names.
3. Schema test: every block contains all required `FeatureBlock v1` fields.
4. Source attribution test: every block has at least one source article tag.
5. Confidence test: all external/novel integrations (for example Pine voice calling) include explicit risk notes.
6. Practicality test: each feature’s setup steps are executable at a “basic setup” level without hidden prerequisites.
7. Prioritization test: impact/effort/dependencies are sufficient to rank top candidates without extra interpretation.

## Acceptance Criteria
- `/Users/luo/Projects/luoji/docs/clawbot-feature-catalog.md` exists and is readable as a planning artifact.
- Catalog is merged (not per-article duplicated), block-based, and decision-ready.
- Every block includes your requested core fields plus prioritization and confidence metadata.
- Future planning can proceed directly from the index + worksheet without re-reading source articles.

## Assumptions and Defaults
- Source of truth is only the 3 provided articles (no external verification pass in this phase).
- Audience is you/your team for future implementation planning.
- Platform context is local OpenClaw-style setup on personal hardware.
- “Basic setup steps” means concise, implementation-oriented steps, not full tutorials.
- Items with high uncertainty are kept in catalog but marked `Experimental` with lower confidence.

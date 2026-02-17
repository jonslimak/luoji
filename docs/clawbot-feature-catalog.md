# Clawbot Feature Catalog (Merged, Decision-Ready)

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

# 04: Reclassify Artifacts safely through the existing worker

**What to build:** The classification worker processes queued policy-change jobs against the current Artifact content and current policy, then applies proposals through the existing deterministic classification and human-review rules. Stale results cannot overwrite newer content or decisions.

**Blocked by:** 03: Persist and schedule reclassification jobs for affected Artifacts.

**Status:** resolved

- [x] Before invoking the classifier, the worker reloads the Artifact and policy inputs and confirms they match the job's expected source and policy versions.
- [x] Results are discarded when source content or relevant policy changes while classification is in progress.
- [x] Accepted proposals use existing deterministic thresholds and authorization rules; uncertain or low-confidence results enter review, and runtime failures remain retryable.
- [x] Human-locked classifications are never silently replaced; conflicts follow the existing locked-review behavior.
- [x] Classification history records the new decision and its provenance while preserving prior decisions.
- [x] Logs and audit records remain redacted and contain no source text, prompts, raw responses, or credentials.

## Comments

- 2026-09-23: Implemented in application commit `9611995`; worker revalidation now checks source text and policy hashes before and between writes, stale results are discarded cleanly, and Realm/legacy worker race coverage was added. Full-suite clone-based tests remain blocked by the host's Windows Git `couldn't create signal pipe` failure; focused worker and related package tests pass.

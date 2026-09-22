# 04: Reclassify Artifacts safely through the existing worker

**What to build:** The classification worker processes queued policy-change jobs against the current Artifact content and current policy, then applies proposals through the existing deterministic classification and human-review rules. Stale results cannot overwrite newer content or decisions.

**Blocked by:** 03: Persist and schedule reclassification jobs for affected Artifacts.

**Status:** ready-for-agent

- [ ] Before invoking the classifier, the worker reloads the Artifact and policy inputs and confirms they match the job's expected source and policy versions.
- [ ] Results are discarded when source content or relevant policy changes while classification is in progress.
- [ ] Accepted proposals use existing deterministic thresholds and authorization rules; uncertain or low-confidence results enter review, and runtime failures remain retryable.
- [ ] Human-locked classifications are never silently replaced; conflicts follow the existing locked-review behavior.
- [ ] Classification history records the new decision and its provenance while preserving prior decisions.
- [ ] Logs and audit records remain redacted and contain no source text, prompts, raw responses, or credentials.

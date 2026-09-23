# 02: Persist prompt provenance through classification work

**What to build:** Operators and later reviewers can determine which prompt contract produced a classification proposal without exposing the prompt, Artifact text, or raw provider response.

**Blocked by:** 01: Define the canonical classification prompt and assessment response.

**Status:** ready-for-agent

- [ ] Classification jobs carry the prompt contract version and digest alongside the existing policy and guidance versions.
- [ ] The worker refuses or discards work whose prompt identity is stale, so a prompt change cannot apply an old proposal to current canonical data.
- [ ] Accepted, pending-review, abstained, and retry outcomes retain safe prompt provenance where classification evidence is recorded.
- [ ] No persisted job, decision, audit record, log, or error contains raw prompt text, Artifact text, raw provider output, or credentials.
- [ ] Tests cover prompt changes during queued work and verify redacted provenance.

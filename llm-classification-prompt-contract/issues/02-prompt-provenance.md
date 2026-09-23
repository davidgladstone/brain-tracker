# 02: Persist prompt provenance through classification work

**What to build:** Operators and later reviewers can determine which prompt contract produced a classification proposal without exposing the prompt, Artifact text, or raw provider response.

**Blocked by:** 01: Define the canonical classification prompt and assessment response.

**Status:** resolved

- [x] Classification jobs carry the prompt contract version and digest alongside the existing policy and guidance versions.
- [x] The worker refuses or discards work whose prompt identity is stale, so a prompt change cannot apply an old proposal to current canonical data.
- [x] Accepted, pending-review, abstained, and retry outcomes retain safe prompt provenance where classification evidence is recorded.
- [x] No persisted job, decision, audit record, log, or error contains raw prompt text, Artifact text, raw provider output, or credentials.
- [x] Tests cover prompt changes during queued work and verify redacted provenance.

## Resolution

Implemented in application commit `1591f98` (`feat: persist classification prompt provenance`). Focused classification, intake, reclassification, and LLM tests pass; `go vet ./...` and compile-only command checks pass. The full suite was also exercised, with only pre-existing Windows Git subprocess tests blocked by the sandbox's `Win32 error 5` signal-pipe restriction.

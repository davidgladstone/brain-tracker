# 03: Verify the canonical prompt against evaluation and providers

**What to build:** Developers can verify that the canonical prompt and response contract behave consistently in offline evaluation, provider contract tests, and an explicitly enabled live smoke test.

**Blocked by:** 01: Define the canonical classification prompt and assessment response.

**Status:** resolved

- [x] The privacy-safe evaluation corpus and recorded proposals use only the canonical full-assessment response shape.
- [x] Golden provider-request tests assert the prompt versioned shape, separation of system instructions from Artifact evidence, allowed-tag guidance, and strict JSON output requirements.
- [x] Offline evaluation reports classification and abstention outcomes without treating malformed responses or provider failures as abstention.
- [x] The opt-in live smoke test checks one positive, one all-absent, and one abstention case using synthetic input and reports only safe provider provenance.
- [x] Ordinary tests remain network-free and credential-free.

## Resolution

Implemented in application commit `fe04e9a` (`Verify canonical LLM prompt contract`). Focused LLM tests, the full suite in the isolated worktree, and `go vet ./...` passed. The live smoke remains opt-in and was not run because provider credentials/access were not configured.

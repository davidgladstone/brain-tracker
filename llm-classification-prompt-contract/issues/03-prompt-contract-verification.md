# 03: Verify the canonical prompt against evaluation and providers

**What to build:** Developers can verify that the canonical prompt and response contract behave consistently in offline evaluation, provider contract tests, and an explicitly enabled live smoke test.

**Blocked by:** 01: Define the canonical classification prompt and assessment response.

**Status:** ready-for-agent

- [ ] The privacy-safe evaluation corpus and recorded proposals use only the canonical full-assessment response shape.
- [ ] Golden provider-request tests assert the prompt versioned shape, separation of system instructions from Artifact evidence, allowed-tag guidance, and strict JSON output requirements.
- [ ] Offline evaluation reports classification and abstention outcomes without treating malformed responses or provider failures as abstention.
- [ ] The opt-in live smoke test checks one positive, one all-absent, and one abstention case using synthetic input and reports only safe provider provenance.
- [ ] Ordinary tests remain network-free and credential-free.

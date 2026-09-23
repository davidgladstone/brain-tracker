# 04: Verify live provider compatibility on demand

**What to build:** An operator or developer can explicitly run a small smoke test against a configured OpenAI-compatible endpoint to verify authentication, structured response parsing, classification, and abstention with the selected provider/model.

**Blocked by:** None (can start immediately).

**Status:** resolved

- [x] The smoke test is opt-in and uses the existing endpoint, model, timeout, retry, and API-key environment configuration.
- [x] It checks a minimal classification and an abstention response using synthetic, non-sensitive input.
- [x] It reports pass/fail and safe provider provenance without printing credentials, prompts, or raw responses.
- [x] Ordinary unit and integration test runs make no external network calls and require no provider credentials.

## Comments

- Added an opt-in test enabled by `MYBRAIN_LLM_LIVE_TEST=1` and pointed at an existing config file through `MYBRAIN_CONFIG`. It remains skipped in ordinary test runs and logs only provider/model provenance.
- Application commit: `c0ccae2`.

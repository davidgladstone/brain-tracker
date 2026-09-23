# LLM Classification Capability

The configured LLM may propose only Realm-defined Controlled Tags. It must be able to explicitly abstain when evidence is insufficient, ambiguous, conflicting, or outside the taxonomy; abstention leaves the Artifact unclassified and unavailable to Audiences. A valid classification with no additional Controlled Tags remains distinct from abstention. Provider failures remain retryable runtime failures and must not be recorded as abstention.

Classification remains deterministic-policy and human-review controlled. Provider requests use configured bounded retry limits. The classifier is evaluated on a stable, representative corpus, and supported OpenAI-compatible endpoints can be checked with an opt-in live smoke test without credentials or network access being required by the normal test suite.

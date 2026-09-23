# LLM Classification Capability

## Destination

Close the implementation gaps between the classification domain model and the production LLM adapter: explicit abstention, configured retries, quality evaluation, and provider interoperability verification.

## Decisions

- [Represent explicit classifier abstention](./issues/01-explicit-classifier-abstention.md): abstention is a successful model outcome, distinct from both a valid zero-additional-tag classification and a provider/runtime failure; it leaves the Artifact unclassified and unavailable to Audiences.
- [Honor configured classification retries](./issues/02-configured-classification-retries.md): production worker calls use the configured bounded retry limit, while runtime failures remain distinct from abstention.
- [Evaluate classification proposals against representative cases](./issues/03-classification-evaluation.md): a repeatable, offline evaluation checks controlled-tag selection and abstention behavior against reviewed examples.
- [Verify live provider compatibility on demand](./issues/04-live-provider-smoke-test.md): an explicitly enabled smoke test checks a configured OpenAI-compatible endpoint without making ordinary tests depend on credentials or network access.

All four tickets are independent and can start immediately.

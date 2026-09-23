# LLM Classification Prompt Contract

## Destination

Make the prompt and response boundary a durable, versioned, testable contract
for classification judgements, with no compatibility shortcuts.

## Decisions

- [Define the canonical prompt and assessment response](./issues/01-canonical-prompt-and-assessments.md): every non-abstaining response contains one assessment for every allowed Controlled Tag; the positive-tags-only shape is removed.
- [Persist prompt provenance through classification work](./issues/02-prompt-provenance.md): jobs and accepted decisions retain prompt identity and digest, while raw prompt material remains excluded from canonical and operational records.
- [Verify the contract against evaluation and providers](./issues/03-prompt-contract-verification.md): golden request tests, the offline corpus, and the opt-in live smoke test exercise the same canonical contract.

Tickets 02 and 03 are independently unblocked after ticket 01.

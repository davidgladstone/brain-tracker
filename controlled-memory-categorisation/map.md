# Controlled Memory Categorisation

Labels: wayfinder:map

## Destination

Produce a design/spec that makes incoming Memory categorisation implementable: the Controlled Tag definition contract, LLM proposal and human-review lifecycle, Memory/Artifact assignment semantics, and the rules by which accepted classification gates derived knowledge generation and retrieval.

## Notes

This is a domain-modeling and human-in-the-loop design effort. Use the existing `CONTEXT.md` vocabulary: `Controlled Tag` is the canonical term for an authorization-relevant label; `Audience`, `Knowledge Projection`, and `Classification Decision` are existing concepts. The LLM is a proposer, never the authorization authority.

The destination is the design boundary, not implementation, provider selection, migrations, or UI work.

## Decisions so far

- [Define the Controlled Tag contract](./issues/01-controlled-tag-contract.md): Controlled Tags are flat stable labels with precise inclusion/exclusion boundaries and examples; optional handling guidance is an advisory manual-review hint, while Audience ACLs remain the access mechanism.
- [Choose Controlled Tag scope and qualification](./issues/02-realm-scope-and-qualification.md): Definitions are Realm-local; bare Realm tags become Realm-qualified at the Installation boundary, and matching names across Realms remain independent.
- [Set the LLM's classification authority](./issues/03-llm-classification-authority.md): The LLM selects only existing tags or abstains; new-tag suggestions go to a separate human taxonomy workflow, and `unclassified` is distinct from `pending_review`.
- [Define Memory and Artifact classification composition](./issues/04-assignment-and-composition.md): Artifacts own content classification; Memory views and derived knowledge union only eligible Artifact tags, hide denied Artifacts, and never surface Memory metadata.
- [Define ambiguity and review handling](./issues/05-ambiguity-and-review-lifecycle.md): Tags receive explicit present/absent/uncertain assessments from confidence bounds; clear Artifacts use Realm membership alone, uncertainty constrains Audiences lacking the possible tag but remains usable by permitted Audiences, and review safely decides whether wider availability can be enabled.
- [Define classification enforcement across curation and retrieval](./issues/06-curation-and-retrieval-enforcement.md): Audiences use default-deny allow/deny policies with wildcard membership implication; possible classifications gate filtered retrieval and curation, and policy changes invalidate affected Publications.
- [Define definition evolution and reclassification](./issues/07-definition-evolution-and-reclassification.md): Controlled Tag identities and published definition versions are immutable; authorization-relevant changes stale prior decisions and projections, preserve historical interpretation, and queue conservative demand/risk-driven reclassification, while retired tags remain available only for legacy interpretation and access.

## Out of scope

- Implementing the classifier, changing the LLM provider runtime, migrating existing data, or building operator UI.
- Designing unrestricted topical or freeform tagging that has no authorization or curation effect.

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

## Not yet specified

- Whether classification is assigned to Memories, Artifacts, or both, and how those decisions compose.
- How accepted classification affects curation eligibility, publication invalidation, and retrieval.
- How tag definitions and decisions evolve without making prior classifications ambiguous.

## Out of scope

- Implementing the classifier, changing the LLM provider runtime, migrating existing data, or building operator UI.
- Designing unrestricted topical or freeform tagging that has no authorization or curation effect.

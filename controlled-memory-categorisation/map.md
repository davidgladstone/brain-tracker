# Controlled Memory Categorisation

Labels: wayfinder:map

## Destination

Produce a design/spec that makes incoming Memory categorisation implementable: the Controlled Tag definition contract, LLM proposal and human-review lifecycle, Memory/Artifact assignment semantics, and the rules by which accepted classification gates derived knowledge generation and retrieval.

## Notes

This is a domain-modeling and human-in-the-loop design effort. Use the existing `CONTEXT.md` vocabulary: `Controlled Tag` is the canonical term for an authorization-relevant label; `Audience`, `Knowledge Projection`, and `Classification Decision` are existing concepts. The LLM is a proposer, never the authorization authority.

The destination is the design boundary, not implementation, provider selection, migrations, or UI work.

## Decisions so far

## Not yet specified

- Whether Controlled Tag definitions are strictly Realm-local or can be shared across Realms.
- The minimum metadata and governance required for a tag to be canonical and usable by a classifier.
- Whether classification is assigned to Memories, Artifacts, or both, and how those decisions compose.
- How the LLM handles multi-label results, abstention, unknown concepts, and proposed new tags.
- How accepted classification affects curation eligibility, publication invalidation, and retrieval.
- How tag definitions and decisions evolve without making prior classifications ambiguous.

## Out of scope

- Implementing the classifier, changing the LLM provider runtime, migrating existing data, or building operator UI.
- Designing unrestricted topical or freeform tagging that has no authorization or curation effect.

# Audience-Aware Knowledge Publication

Labels: wayfinder:map

## Destination

Produce an implementable design/spec for audience-specific curation: deterministic selection of authorized, relevant Artifacts from Memories; synthesis of one or more Knowledge Variants from related Memories; hierarchical Area indexes with summaries; and atomic publication semantics that preserve provenance and prevent content leakage.

## Notes

This is a domain-modeling and human-in-the-loop design effort. Use the vocabulary in `CONTEXT.md`: `Audience`, `Audience Access Policy`, `Audience-visible Memory`, `Knowledge Projection`, `Knowledge Variant`, `Area`, `Publication`, and `Catalog`. Reconcile the existing audience-aware curation and knowledge-kernel specs before proposing new behavior. Authorization remains deterministic; an LLM may select, synthesize, place, or summarize only after deterministic eligibility filtering.

Human concern: the safety-first invalidation and rewrite approach may have significant performance and usability costs. Those costs must be made visible and addressed without weakening the no-leakage guarantee.

The destination is the design boundary, not implementation, provider selection, storage migration, or UI work.

Standing safety constraint: reclassification or policy change that removes an Artifact from an Audience immediately revokes the affected Audience Publication. Unrewritten Knowledge Variants and Area summaries must not remain readable; republishing must regenerate affected Areas bottom-up through the root.

## Decisions so far

- [Define publication and re-curation lifecycle for audience projections](./issues/05-publication-and-recuration-lifecycle.md): reads fail closed after revocation, publication switches are atomic, summaries propagate bottom-up, and the current safe implementation pays for this with full-corpus regeneration and conservative audience invalidation.
- [Reconcile Knowledge Document, Knowledge Variant, and Area terminology](./issues/06-existing-knowledge-model-reconciliation.md): `KnowledgeVariant` is the current audience-specific derived document; `Knowledge Projection`, `Publication`, `Area`, and `Catalog` retain distinct boundaries, while older document terminology is limited to compatibility and migration seams.
- [Audience-aware curation and trust projections](../../docs/superpowers/specs/2026-09-06-audience-aware-curation-design.md): Audiences receive separate Knowledge and Area projections; curation is independently authorized per audience; incremental curation and Dreaming have different breadth; Areas are many-to-one indexes with bottom-up summaries.
- [Define classification enforcement across curation and retrieval](../controlled-memory-categorisation/issues/06-curation-and-retrieval-enforcement.md): authorization evaluates each Artifact's possible classification, denied Artifacts behave as absent, and a derived Knowledge Variant carries the union of contributing classifications.
- [Define Memory and Artifact classification composition](../controlled-memory-categorisation/issues/04-assignment-and-composition.md): Memory views contain only eligible Artifacts, hide Memory metadata, and derived knowledge uses only the eligible contributing Artifacts.
- [Knowledge Kernel and MCP Gateway](../../docs/superpowers/specs/2026-08-22-second-brain-knowledge-kernel-mcp-design.md): Knowledge Documents are derived, Areas provide progressive disclosure, and indexes are rebuildable navigation projections rather than canonical truth.
- [Audience enforcement under uncertainty](../../docs/adr/0004-audience-enforcement-under-uncertainty.md): possible classifications constrain access conservatively, including for derived material.
- [Operation-scoped eligibility capture](../../docs/adr/0008-operation-scoped-eligibility-capture.md): curation and reads must use a coherent captured authorization view rather than mixing state from different observations.

## Not yet specified

- The precise relevance contract between an Audience's curation brief and eligible Artifacts, including whether selection is per Artifact, per Memory, or per emerging topic and how partial Memory views are handled.
- The identity and lifecycle of a Knowledge Variant synthesized from multiple related Memories: topic boundaries, stable identity across rewrites, split/merge behavior, and source-version invalidation.
- How synthesis preserves provenance, represents disagreement or temporal change, and avoids turning an editorial summary into canonical truth.
- The contract for Area placement, hierarchy changes, and summary generation when knowledge is shared across Areas or when a descendant is not visible to the audience.
- Which incremental and Dreaming operations are permitted to rewrite existing variants or Areas, and how human preferences survive automatic maintenance.
- How immediate revocation and hierarchical rewrites affect latency, availability, operational load, and user experience, and which safe optimizations or progressive states can mitigate those costs.

## Out of scope

- Changing the Controlled Tag taxonomy or classification lifecycle.
- Authenticated identity and group management.
- Implementing an LLM provider, curation worker, or operator UI.
- Treating freeform topical tags as authorization.

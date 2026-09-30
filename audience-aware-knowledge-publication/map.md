# Audience-Aware Knowledge Publication

Labels: wayfinder:map

## Destination

Produce an implementable design/spec for audience-specific curation: deterministic capture of authorized Artifacts from Memories; retrieval-oriented synthesis of one or more Knowledge Variants from related Memories; hierarchical Area indexes with summaries; and atomic publication semantics that preserve provenance and prevent content leakage.

## Notes

This is a domain-modeling and human-in-the-loop design effort. Use the vocabulary in `CONTEXT.md`: `Audience`, `Audience Access Policy`, `Audience-visible Memory`, `Knowledge Projection`, `Knowledge Variant`, `Area`, `Publication`, and `Catalog`. Reconcile the existing audience-aware curation and knowledge-kernel specs before proposing new behavior. Authorization remains deterministic; an LLM may select, synthesize, place, or summarize only after deterministic eligibility filtering.

Human concern: the safety-first invalidation and rewrite approach may have significant performance and usability costs. Those costs must be made visible and addressed through an explicit Installation availability policy rather than an accidental mixture of old and new authorization state.

The destination is the design boundary, not provider selection, storage migration, or UI work. Implementation follow-ons are tracked as task tickets after the design decisions are accepted.

Standing publication constraint: every Publication is an internally consistent atomic snapshot. Content drift and coverage drift do not make the selected Publication unavailable and are not exposed as MCP response flags. A classification, Audience Access Policy, Realm availability, or provenance change that may make selected material unauthorized creates safety drift; the Installation's `safety_drift_grace_period` controls whether the previous complete Publication remains serveable, with `0s` failing closed immediately. Republished Areas and summaries must be rebuilt consistently through the affected hierarchy; a grace-served revision must never be mixed with a partially rebuilt or partially reauthorized view.

## Decisions so far

- [Define publication and re-curation lifecycle for audience projections](./issues/05-publication-and-recuration-lifecycle.md): current implementation research established atomic publication, source and policy validation, and bottom-up summary processing; the follow-on availability tradeoff is recorded in ADR 0014.
- [Implement publication drift and safety-drift availability](./issues/07-publication-drift-availability.md): implement the Installation-level safety-drift grace period while keeping content and coverage drift serveable and preserving complete-revision atomicity.
- [Reconcile Knowledge Document, Knowledge Variant, and Area terminology](./issues/06-existing-knowledge-model-reconciliation.md): `KnowledgeVariant` is the current audience-specific derived document; `Knowledge Projection`, `Publication`, `Area`, and `Catalog` retain distinct boundaries, while older document terminology is limited to compatibility and migration seams.
- [Define audience relevance and source selection](./issues/01-audience-relevance-and-selection.md): every eligible Artifact belongs to the captured Publication input set; the Audience brief guides grouping, synthesis, placement, and retrieval usefulness rather than excluding authorized material.
- [Define multi-Memory Knowledge Variant identity and synthesis](./issues/02-multi-memory-knowledge-variant.md): Artifacts are the atomic provenance units, coherent retrieval units may synthesize across Memories and Realms, and Publication-scoped IDs may be retained only for subject-preserving rewrites.
- [Define provenance and disagreement handling for synthesized knowledge](./issues/03-provenance-and-disagreement-in-synthesis.md): initial provenance is Variant-level with source-version hashes; synthesis may paraphrase and connect sources but must preserve meaningful disagreement, time scope, and uncertainty.
- [Define Area placement, hierarchy, and summary semantics](./issues/04-area-hierarchy-and-summary-contract.md): Areas are many-to-one navigation indexes with Area-owned link synopses, bottom-up semantic convergence, targeted incremental updates, and broader Dreaming reorganization.
- [Implement targeted Incremental Curation and navigation synopses](./issues/08-targeted-incremental-curation-and-navigation-synopses.md): replace full-corpus incremental regeneration with dependency-targeted Variant and Area updates while preserving complete staged validation.
- [Audience-aware curation and trust projections](../../docs/superpowers/specs/2026-09-06-audience-aware-curation-design.md): Audiences receive separate Knowledge and Area projections; curation is independently authorized per audience; incremental curation and Dreaming have different breadth; Areas are many-to-one indexes with bottom-up summaries.
- [Define classification enforcement across curation and retrieval](../controlled-memory-categorisation/issues/06-curation-and-retrieval-enforcement.md): authorization evaluates each Artifact's possible classification, denied Artifacts behave as absent, and a derived Knowledge Variant carries the union of contributing classifications.
- [Define Memory and Artifact classification composition](../controlled-memory-categorisation/issues/04-assignment-and-composition.md): Memory views contain only eligible Artifacts, hide Memory metadata, and derived knowledge uses only the eligible contributing Artifacts.
- [Knowledge Kernel and MCP Gateway](../../docs/superpowers/specs/2026-08-22-second-brain-knowledge-kernel-mcp-design.md): Knowledge Documents are derived, Areas provide progressive disclosure, and indexes are rebuildable navigation projections rather than canonical truth.
- [Audience enforcement under uncertainty](../../docs/adr/0004-audience-enforcement-under-uncertainty.md): possible classifications constrain access conservatively, including for derived material.
- [Operation-scoped eligibility capture](../../docs/adr/0008-operation-scoped-eligibility-capture.md): curation and reads must use a coherent captured authorization view rather than mixing state from different observations.

## Implementation follow-ons

- Add Area-owned Variant and child-Area link synopses, with exact input hashes and semantic comparison that stops unchanged synopsis propagation before it reaches ancestors.
- Replace full-corpus Incremental Curation with dependency-targeted regeneration: use published Variant provenance to find affected Variants, update affected Area ancestors bottom-up, preserve unaffected material, and retain full staged validation with a safe full-Audience fallback.
- [Implement Artifact semantic profiles and targeted placement](./issues/09-artifact-semantic-profiles-and-targeted-placement.md): generate reusable Installation-local Artifact profiles and use them to attach newly eligible material to bounded Variant and Area work without rebuilding an entire Audience.
- [Implement the bounded Dreaming controller](./issues/10-bounded-dreaming-controller.md): make Dreaming fingerprint-aware, resumable, budgeted, and fair across multiple Audiences and attached Realms, with partial work-unit boundaries and atomic publication.
- [Add Navigation usage and adaptive retrieval](./issues/11-navigation-usage-and-adaptive-retrieval.md): record decayed Audience-scoped retrieval usage and use it only for ranking, promotion, and bounded Dreaming triggers, never for authorization or Variant facts.
- Keep semantic profiles, dependency indexes, usage telemetry, and Catalog data Installation-local and rebuildable; none may replace canonical authorization or provenance validation.

## Out of scope

- Changing the Controlled Tag taxonomy or classification lifecycle.
- Authenticated identity and group management.
- Implementing an LLM provider, curation worker, or operator UI.
- Treating freeform topical tags as authorization.

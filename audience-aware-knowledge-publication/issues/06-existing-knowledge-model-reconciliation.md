# Reconcile Knowledge Document, Knowledge Variant, and Area terminology

Type: research
Status: resolved
Assignee: Codex
Labels: wayfinder:research

## Question

Where does the repository still use the earlier Knowledge Document/Area model, and what terminology or behavioral seams must the destination spec reconcile with the current `CONTEXT.md` model of Knowledge Variant, Knowledge Projection, Publication, and Catalog?

Inspect the relevant specs, domain types, file formats, and tests. Identify whether the old Knowledge Document identity, provenance, relations, and index-summary assumptions conflict with the audience-aware model, and list the exact terms and boundaries that should be preserved or retired. Do not implement changes.

## Comments

### Resolution

Research report: [Knowledge model reconciliation research](../../docs/research/2026-09-24-knowledge-model-reconciliation.md).

The current implementation already uses `KnowledgeVariant` for the
audience-specific derived document and separates the complete audience
`KnowledgeProjection`, its atomic `Publication`, and the rebuildable
`Catalog`. The older `KnowledgeDocument` model remains only in historical
design prose, migration input, and the existing `knowledge_documents` wire
field. Claims, Evidence, Relations, human-owned sections, and the old
filesystem-authoritative Area semantics are not current guarantees and must
not be inherited by later design tickets without an explicit decision.

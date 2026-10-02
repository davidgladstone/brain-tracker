# Keep the Catalog in sync and rebuildable

Type: grilling
Status: resolved
Claimed by: Codex

## Question

Is SQLite still the search Catalog, and how is it currently updated, validated, and rebuilt relative to canonical Realm data and Publications? Establish what happens on interrupted writes, stale or missing index data, and concurrent changes, then identify what guarantees or changes are needed for reliable search as the corpus grows. SQLite remains a rebuildable index, not the authority for content or authorization.

## Comments

### Resolution

Keep SQLite with FTS5 as the Installation Catalog and use full atomic rebuilds from the selected Audience Publications for now; revisit incremental indexing only if measured rebuild cost warrants it. The Catalog stays rebuildable and non-authoritative: every result is reauthorized against its pinned Publication and safety state. A missing or stale Catalog returns `catalog_stale` promptly and requests repair through one serialized, coalescing in-memory rebuild worker, triggered at startup, after Publication changes, and on stale or missing reads. The worker retries failures with backoff; no durable repair queue is needed because Catalog state is derivable and rebuilt at startup. A read must use a stable matching Catalog and Publication generation or fail without partial results. Keep the prior Catalog generation available for the same five-minute superseded-Publication read grace so already-pinned readers can complete; new reads use the selected generation, and every old-generation read remains subject to the selected Publication's safety-drift availability gate.

Remove MCP request tracing (`brain.trace`, response `trace_id`, and trace rows in the Catalog). The current records cannot explain results or failures and are not required. Keep accounting for all LLM calls as a separate design concern; it does not belong in the Catalog decision.

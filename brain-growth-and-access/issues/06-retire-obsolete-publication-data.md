# Retire obsolete Publication data

Type: grilling
Status: resolved
Claimed by: Codex

## Question

What data is retained across successive Publications today, where does duplication occur, and which older published trees can be removed safely? Determine the lifecycle, rollback and recovery needs, provenance constraints, and an eventual cleanup policy that avoids deleting the selected or otherwise required Publication state.

## Comments

### Resolution

Each successful Publication creates a full immutable revision tree and atomically changes the selected pointer. Incremental curation copies unchanged Knowledge Variant and Area documents, including repeated provenance, into each new tree. Old revisions are currently retained indefinitely; the Catalog indexes only the selected Publication. A failed or incomplete curation run leaves the previous selected Publication in place, and a failed pointer commit restores the staging tree for retry.

Add an Installation-configured read grace, defaulting to five minutes and independent of the safety-drift grace. Start it when a Publication is superseded. Only a read already pinned to the superseded revision may continue during this window; new reads always resolve the selected Publication, and superseded revisions are not rollback targets. When the window expires, the old tree may be collected and any remaining read using it must fail.

Every read pinned to a superseded revision remains subject to the selected Publication's safety-drift availability gate. If access to the selected Publication is blocked, reads of superseded revisions are blocked as well. The read grace neither resets nor extends the safety-drift deadline. This preserves a bounded in-flight read while ensuring retained bytes do not grant access after the current Publication becomes unavailable.

The current read-session implementation reports `catalog_stale` when a Publication pointer changes during a request. The eventual implementation must allow a pinned read to finish within its read grace when the selected safety-drift gate still permits access. No new domain vocabulary or change to canonical provenance is needed.

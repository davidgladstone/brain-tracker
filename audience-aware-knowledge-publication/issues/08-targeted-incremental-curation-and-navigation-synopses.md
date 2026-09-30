# Implement targeted Incremental Curation and navigation synopses

Type: task
Status: resolved
Labels: wayfinder:task, ready-for-agent

## What to build

Implement the resolved audience-publication decisions for targeted
Incremental Curation and Area-owned navigation synopses.

## Requirements

- Use published Variant provenance to identify the affected Variant dependency
  closure for changed Artifacts.
- Regenerate affected Variants and affected Area ancestors only; preserve
  unaffected Variants and Areas by copying them into staging.
- Handle a newly eligible Artifact by attaching it to an existing coherent
  retrieval unit or creating a new Variant/Area; use a full Audience rebuild
  when the impact cannot be determined safely.
- Generate short synopses for Variant links and child-Area links. Keep these
  synopses in Area navigation documents rather than adding a navigation-summary
  field to `KnowledgeVariant`.
- Process Area synopses bottom-up. Reuse exact-hash matches without model work;
  retain the prior synopsis when semantic comparison says the meaning is
  materially unchanged; propagate only material changes to ancestors. Treat
  comparison failure or uncertainty conservatively as a change.
- Always validate the complete staged Projection before atomic publication,
  including copied unaffected material.

## Verification

- A single Artifact update does not regenerate unrelated Variants or Areas.
- A changed multi-Artifact Variant and all affected Area ancestors are rebuilt.
- A revoked Artifact is absent from regenerated Variant bodies, provenance, and
  navigation synopses.
- Unchanged Areas retain their bytes and do not invoke synopsis comparison.
- A semantically unchanged leaf synopsis does not trigger ancestor model work.
- Structural link changes still publish even when prose remains equivalent.
- Failed validation leaves the prior complete Publication selected.

## Dependencies

- Compatible with the publication drift and availability implementation in
  issue 07; it does not need to wait for that work because staging, complete
  validation, and atomic publication already provide its safety seam.
- Uses the resolved source, Variant, provenance, and Area contracts in issues
  01-04.

## Comments

### Resolution

Implemented and verified targeted Incremental Curation and Area-owned
navigation synopses. Published Variant provenance identifies the affected
dependency closure; affected Variants and Area ancestors are regenerated while
unaffected documents are copied byte-for-byte into a fully validated staging
revision. Newly eligible Artifacts use the safe full-Audience fallback until
profile-driven targeted placement is implemented by issue 09.

Variant and child-Area link synopses remain Area-owned navigation material.
Area summaries converge bottom-up with exact input reuse, semantic comparison,
conservative comparison failure handling, and structural-link publication even
when prose is unchanged. Revoked sources are excluded from regenerated body,
provenance, and navigation output.

Verification is covered by the curation public-seam tests and the following
commands:

```text
go test ./internal/curation ./internal/projection ./internal/read ./internal/catalog ./internal/reclassification -count=1
go test ./... -count=1
go vet ./...
```

All passed. Application commits: `619ff49`, `46d4371`, and `ee8b009`.

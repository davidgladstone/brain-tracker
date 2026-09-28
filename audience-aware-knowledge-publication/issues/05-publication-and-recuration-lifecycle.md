# Define publication and re-curation lifecycle for audience projections

Type: research
Status: resolved
Assignee: Codex
Labels: wayfinder:research

## Question

What do the current implementation, tests, and prior specs already guarantee about incremental curation, Dreaming, projection staleness, atomic publication, and audience-filtered reads, and where do they leave the multi-Memory synthesis behavior unspecified?

Inspect the repository's curation, projection, catalog, read, and MCP code plus the existing design specs and ADRs. Report concrete current behavior, relevant test names, and contradictions or gaps that later design tickets must resolve. Pay particular attention to whether reclassification or policy revocation immediately denies an affected Audience's old Knowledge Variants and Area summaries, and whether a rebuild propagates summaries bottom-up through the hierarchy. Also identify performance and usability consequences of this safety-first approach and safe mitigation seams that later design work should consider. Do not implement changes.

## Comments

### Resolution

Research report: [Publication and re-curation lifecycle research](../../docs/research/2026-09-24-publication-recuration-lifecycle.md).

The implementation already enforces the central safety behavior: source text is filtered before generation; current reads reauthorize published variants; stale local projections are denied; and Area summaries are withheld when an unauthorized dependency is present. Publication is staged and atomically switched, so failed rebuilds do not replace the last revision.

The main unresolved tradeoff is cost. Incremental curation currently regenerates the complete eligible Audience corpus, authorization-relevant reclassification conservatively invalidates all audiences consuming the Realm, and a changed dependency causes bottom-up Area-summary processing. The next design tickets must decide whether dependency-targeted rebuilds, safe caches, batching, and user-visible rebuilding status can reduce performance and availability costs without serving stale restricted content.

### Follow-on decision

The publication-availability tradeoff is now resolved by
[ADR 0014](../../docs/adr/0014-publication-availability-uses-safety-drift-grace-period.md).
Content and coverage drift remain serveable without response flags. Safety drift
uses the Installation's `safety_drift_grace_period`, with `0s` preserving
fail-closed behavior and a positive duration serving the previous complete
Publication until the detection-based deadline. Implementation is tracked in
`07-publication-drift-availability.md`.

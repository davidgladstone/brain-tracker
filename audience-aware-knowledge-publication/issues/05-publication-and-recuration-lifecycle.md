# Define publication and re-curation lifecycle for audience projections

Type: research
Status: open
Labels: wayfinder:research

## Question

What do the current implementation, tests, and prior specs already guarantee about incremental curation, Dreaming, projection staleness, atomic publication, and audience-filtered reads, and where do they leave the multi-Memory synthesis behavior unspecified?

Inspect the repository's curation, projection, catalog, read, and MCP code plus the existing design specs and ADRs. Report concrete current behavior, relevant test names, and contradictions or gaps that later design tickets must resolve. Pay particular attention to whether reclassification or policy revocation immediately denies an affected Audience's old Knowledge Variants and Area summaries, and whether a rebuild propagates summaries bottom-up through the hierarchy. Also identify performance and usability consequences of this safety-first approach and safe mitigation seams that later design work should consider. Do not implement changes.

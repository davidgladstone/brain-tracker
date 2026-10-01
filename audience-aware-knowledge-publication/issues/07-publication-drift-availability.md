# Implement publication drift and safety-drift availability

Type: task
Status: resolved
Labels: wayfinder:task

## What to build

Implement the publication-availability behavior defined by
[ADR 0014](../../../docs/adr/0014-publication-availability-uses-safety-drift-grace-period.md)
and the publication vocabulary in [`CONTEXT.md`](../../../CONTEXT.md).

## Requirements

- Add one Installation-local `safety_drift_grace_period` configuration value,
  defaulting to `0s`; reject invalid or negative durations.
- Treat ordinary Artifact/content changes and newly eligible material as
  internal re-curation work. They do not make the selected Publication
  unavailable, and MCP responses do not expose content-drift or coverage-drift
  flags.
- Detect and persist the start of safety drift when a classification, Audience
  Access Policy, Realm availability, or provenance change may make selected
  Publication material unauthorized.
- With a zero grace period, fail closed immediately. With a positive grace
  period, serve the previous complete Publication until the deadline measured
  from safety-drift detection.
- Do not reset an unresolved safety-drift deadline when additional changes
  arrive. Clear it only after a successful, validated atomic Publication
  replacement.
- Grace mode must serve one complete prior revision. It must not combine old
  Area summaries or Knowledge Variants with newly filtered or partially rebuilt
  content.
- When the deadline expires, make the Audience unavailable as a whole rather
  than returning a partial tree or partial Catalog results.
- Keep filesystem Publication and Catalog consistency checks intact. A Catalog
  must index the complete revision actually selected for serving.

## Verification

- Content-only Artifact updates continue serving the previous complete
  Publication while re-curation is pending.
- Newly eligible Artifacts do not make an Audience unavailable and do not add
  response flags.
- Safety drift fails closed immediately with the default `0s` configuration.
- Positive grace serves the previous complete revision, including Area
  synopses, until the detection-based deadline.
- Repeated safety changes do not extend the original unresolved deadline.
- A successful replacement clears safety drift and switches the filesystem and
  Catalog atomically.
- Failed or incomplete rebuilds leave the previous complete revision and its
  configured availability behavior intact.
- Expired grace rejects the Audience without exposing a partial Publication.

## Out of scope

- Per-Audience availability overrides.
- New classification or Audience Access Policy semantics.
- Exposing content-drift, coverage-drift, or safety-drift flags in ordinary MCP
  retrieval responses.

## Comments

- 2026-10-01: Verified the Installation-local grace-period configuration,
  persisted detection deadline, prior-revision serving, and Catalog behavior.
  The prior-revision reader now rejects the entire Audience if a variant fails
  provenance validation during grace, preserving complete-publication
  semantics. Focused Installation, Catalog, Projection, Curation, and MCP
  packages passed; the full suite is blocked only by existing Windows Git
  clone tests failing with `couldn't create signal pipe`. Implementation is in
  application commits `13920b3` and `69ddcb3`.

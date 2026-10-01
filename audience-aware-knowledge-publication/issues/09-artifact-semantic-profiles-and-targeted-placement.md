# Implement Artifact semantic profiles and targeted placement

Type: task
Status: resolved
Labels: wayfinder:task, ready-for-agent

## What to build

Implement the Installation-local Artifact semantic-profile cache and use it to
handle newly eligible or otherwise unplaced Artifacts without defaulting to a
full eligible-corpus Knowledge rebuild.

Profiles are shared across Audiences and attached Realms, keyed by Artifact
content hash plus analyzer/profile version, and remain rebuildable derived
state. They may contain concepts, entities, themes, semantic fingerprints,
and embeddings, but they are never an authorization or provenance authority.

## Requirements

- Generate or refresh one profile for each changed Artifact content version.
- Reuse an unchanged profile across all Audiences in the Installation.
- Invalidate profiles when the Artifact content hash or analyzer version changes.
- Use profile lookup to identify candidate existing Variant units and Area
  placements for a newly eligible Artifact.
- Reauthorize every selected Artifact for the target Audience before any
  audience curation model receives its text.
- Regenerate only the affected Variant unit and Area ancestors when the impact
  is determined safely; create a new Variant/Area when no existing unit is a
  truthful placement.
- Retain a safe full-Audience fallback when candidate impact cannot be
  determined.
- Keep profiles and candidate indexes Installation-local and rebuildable; they
  must not enter Realm history or replace publication provenance.

## Verification

- A newly eligible unrelated Artifact does not send the entire Audience corpus
  to the Knowledge generator when its profile identifies a bounded placement.
- Profile generation is deduplicated across two Audiences that consume the
  same Artifact.
- A content-hash or analyzer-version change causes recomputation.
- Candidate lookup cannot make a denied Artifact eligible or expose its text to
  an Audience model call.
- An ambiguous candidate set takes the safe full-Audience path and preserves
  atomic publication behavior.

## Comments

- 2026-10-01: Reused Installation-local profiles by content hash and analyzer
  version, with normalized-term and digest validation before cache reuse.
  Strong unique matches regenerate only the existing Variant and Area
  ancestors; no-match sources generate bounded new Variant units and link from
  the existing root Area. Ambiguous matches or generated-ID conflicts retain
  the safe full-Audience fallback. Focused profile, curation, and projection
  suites passed; full-suite failures remain the Windows Git clone
  `couldn't create signal pipe` environment issue. Implementation is in
  application commits `13920b3` and `eae2688`.

# Implement Artifact-level possible-classification authorization

Type: task
Status: resolved
Assignee: Codex

## Comments

### Claim

Claimed for implementation. The first vertical slice will establish the public Audience authorization seam, then use it to drive Artifact-level filtering without changing the LLM provider yet.
Labels: wayfinder:task

### Implementation

Implemented in application commit `67a35d4`.

- Added explicit per-tag `present`, `absent`, and `uncertain` assessments with effective and possible classifications.
- Added Audience allow/deny ACLs, Realm wildcard membership implication, and deny precedence.
- Made canonical Memory records support multiple Artifacts with independent Sources.
- Enforced Artifact-level authorization in snapshot and request-scoped retrieval/curation paths; denied Artifacts are omitted and a Memory with no eligible Artifacts yields no source.
- Preserved metadata exclusion from projection sources and carried assessment data through canonical classification storage.

Focused domain, policy, installation, realm, classification, and projection tests pass. A full `go test ./...` run was attempted, but Git-origin revalidation in existing Windows-heavy integration tests exceeded the test timeout; the changed projection package also hits that environmental timeout in its publication-integrity tests.

## Goal

Implement the domain and enforcement seam that makes the resolved classification model real: per-Artifact assessments, possible/effective classifications, Audience allow/deny policy, and Artifact-level filtering for retrieval and curation.

The current code still stores a single tag set and proposal confidence, uses allow-only Audience rules, and gates Memory and Artifact classification together. This task establishes the authorization contract before changing the LLM adapter.

## Scope

### Classification contract

- Represent a Controlled Tag assessment as `present`, `absent`, or `uncertain` for each relevant Realm-local tag.
- Preserve the distinction between evidence-based `absent` and an omitted positive proposal.
- Define an Artifact's effective classification as its present Controlled Tags plus Realm membership.
- Define its possible classification as present plus uncertain Controlled Tags plus Realm membership.
- Keep Memory-level classification derived from eligible Artifacts; do not make it an independent authorization decision.
- Preserve source/content and policy-definition version checks so stale decisions fail closed.

### Audience authorization

- Replace allow-only evaluation with explicit allow and deny rules over Realm-qualified tags.
- Default to deny.
- Require an Audience to permit every tag in an Artifact's possible classification.
- Make `realm.*` imply bare Realm membership, such as `personal.*` implying `personal`.
- Ensure an explicit deny overrides a broad allow.
- Keep authorization in the Audience policy, not in retrieval or curation query parameters.

### Retrieval and curation

- Evaluate each Artifact independently; a denied Artifact behaves as though it does not exist.
- A Memory with at least one eligible Artifact remains visible as an Audience-filtered Memory view.
- A Memory with no eligible Artifacts is not found.
- An Artifact with no additional Controlled Tags remains available to an Audience permitted for its Realm membership alone.
- An Artifact with an uncertain tag is unavailable to Audiences lacking that tag but may be retrieved and curated by Audiences that permit it.
- A Knowledge Variant may use only eligible Artifacts, and its possible classification is the union of the possible classifications of its contributing Artifacts.
- Do not expose Memory metadata through retrieval or derived knowledge.

## Acceptance criteria

- Unit tests cover exact tag allows, default deny, Realm wildcard membership implication, explicit deny precedence, and the requirement that all possible tags are permitted.
- Classification tests cover independent `present`, `absent`, and `uncertain` assessments and confirm that omission is not treated as evidence of absence.
- Projection/retrieval tests cover a Memory with two Artifacts where one is visible and the other is hidden, including the no-eligible-Artifacts case.
- Tests confirm that an Audience with the possible tag can use uncertain material while an Audience without it cannot.
- Tests confirm that generated provenance and retrieval responses contain permitted Artifact content but no Memory metadata.
- Existing source-hash and policy-version fail-closed checks remain intact.
- `go test ./...` passes.

## Out of scope

- Changing the LLM provider or response schema beyond the minimum domain seam needed for fixtures.
- Building manual review UI or a reclassification queue.
- Implementing tag-definition evolution, retirement migration, or Audience-policy migration workflows.
- Adding unrestricted freeform tags.

## Implementation notes

Likely starting points are `internal/domain`, `internal/realm`, `internal/classification`, `internal/installation`, `internal/projection`, and their existing Go tests. Preserve the canonical Realm/Installation boundary and the private metadata rules already recorded in `CONTEXT.md` and ADRs 0001–0006.

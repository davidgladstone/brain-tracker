# Implement the bounded Dreaming controller

Type: task
Status: open
Labels: wayfinding:task, ready-for-agent

**Blocked by:** 08, 09

## What to build

Replace monolithic whole-Audience Dreaming with a deterministic controller
that selects bounded, resumable work units across multiple Audiences and
attached Realms.

Dreaming must be a broad optimization process, but one run must not assume
that the complete Installation fits into one model call or one uninterrupted
job. The controller selects the scope; model-backed curation operates only on
that scope.

## Requirements

- Capture an input fingerprint for each Audience and relevant operation,
  including eligible Artifact content/classification state, policy versions,
  Audience brief and Concerns, prompt/model versions, semantic-profile
  analyzer version, planner version, and projection schema version.
- Treat Dreaming as a no-op when the last relevant work completed successfully,
  the current fingerprints match, and there is no pending or forced work.
- Do not mark an Audience fully Dreamed after a partial or failed run; retain
  resumable incomplete work and scoped completion fingerprints.
- Select work units from deterministic seeds such as changed Artifacts,
  profile changes, policy/brief changes, stale scopes, structural pressure, and
  explicit operator requests.
- Bound each work unit by configured Artifact, Variant, Area, token, model-call,
  and elapsed-time budgets.
- Define explicit frozen boundaries for partial Area reorganization; the model
  must not expand the scope implicitly.
- Schedule work fairly across Audiences and Realms so one large Audience cannot
  monopolize the worker.
- Copy unaffected material into staging, validate the complete candidate
  Knowledge Projection, and publish each Audience revision atomically.
- Escalate or split work when a candidate scope exceeds its budget or cannot
  be safely bounded.

## Verification

- A completed Dreaming run with unchanged relevant inputs performs no model
  work.
- A changed prompt, profile analyzer, classification input, Artifact, or
  Audience brief dirties only the affected operation or scope where possible.
- A failed or interrupted work unit is retried rather than incorrectly treated
  as current.
- A partial work unit cannot publish a disconnected, uncovered, unauthorized,
  or partially validated Projection.
- Multiple Audiences and Realms receive fair scheduling under a constrained
  work budget.
- A model cannot expand a partial scope beyond its deterministic boundary.

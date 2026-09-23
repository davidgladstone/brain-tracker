# 03: Persist and schedule reclassification jobs for affected Artifacts

**What to build:** When a validated policy change identifies Artifacts for reclassification, Brain records durable work that survives restart and avoids silently losing or duplicating pending work. Operators can rely on each affected Artifact eventually being considered under the new policy inputs.

**Blocked by:** 02: Identify Artifacts affected by classification-policy changes.

**Status:** resolved

- [x] Each queued job identifies its Realm, Memory, Artifact, current source hash, and relevant classification-policy and guidance versions.
- [x] Jobs are deduplicated for the same Artifact and target policy inputs; a newer source or policy version supersedes stale pending work safely.
- [x] An interrupted lease is recoverable after restart, and retry timing is durable.
- [x] Queue state contains no source text, prompt, raw model response, or credential.
- [x] Tests demonstrate that a policy change schedules all and only the Artifacts selected by the reclassification plan.

## Comments

- 2026-09-23: Implemented in application commit `48d559a`; extended versioned classification jobs, durable superseding/deduplication, plan scheduling, and regression coverage. Full-suite command and Realm-sync tests encountered the existing Windows Git `couldn't create signal pipe` environment failure; changed packages passed focused tests.

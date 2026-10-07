# 04: Review Intake classification exceptions

**What to build:** An Intake reviewer resolves an uncertain Artifact classification using the selected Realm's Controlled Tags, saves the decision, and returns the Artifact to normal processing.

**Blocked by:** 03 Add content to Intake.

**Status:** resolved
**Assignee:** Codex (current session)

- [x] Intake review lists only exceptions that need classification review; routine queued work remains in Queues.
- [x] Review selects the Artifact's Realm and permits zero or more Realm-defined Controlled Tags.
- [x] Tag wording and handling guidance are available while reviewing.
- [x] Review does not assign Areas or free-form authorization tags.
- [x] Saving creates the appropriate human classification decision and queues subsequent processing through shared application operations.
- [x] A focused review route selects and highlights the requested Artifact.
- [x] HTTP integration tests verify both classification state transition and reprocessing behavior.
- [x] A locked decision requires a distinct unlock action before a separate tag decision; unlock preserves the current tags and keeps the item available for review.

## Comments

### 2026-10-07 scope clarification

User confirmed that an accepted classification with an empty Controlled Tag list is valid and means Realm membership alone applies. It is distinct from `unclassified`, which means no accepted decision exists. The API/UI should send and retain an explicit empty list for the former; lifecycle state, not list length, determines whether a decision exists.

### 2026-10-07 implementation

Added a Review destination that lists queued Artifact exceptions by attached Realm, opens the requested Artifact from Intake status, shows its text plus Realm tag descriptions/handling guidance, and posts explicit tag selections (including `[]`) and rationale through the shared application review operation. The API verifies the target remains in the review queue before returning text or accepting a decision. Successful reviews enqueue curation. Focused Web API and daemon composition tests passed; the complete ordinary suite passed all Go packages and nine browser tests. Empty-tag semantics are recorded in ADR 0028.

### 2026-10-07 locked-review clarification and implementation

User chose two separate actions for locked classifications: unlock first, then submit a tag decision. The UI now provides an explicit unlock form with its own rationale. Unlock preserves the current Controlled Tags and leaves the Artifact in the review queue; the second form records the replacement tags and completes the review.

The regression test exposed and fixes a queue-removal bug: Realm classification commits with no queue item did not identify the Artifact when removing a completed review. Queue updates now receive the Artifact ID explicitly. `TestLockedIntakeReviewRequiresSeparateUnlockAndTagDecision` verifies the intermediate unlocked state, retained queue entry and tags, final separate tag decision, persisted classification, and queue removal.

Verification: focused `go test ./internal/webapi -run '^TestLockedIntakeReviewRequiresSeparateUnlockAndTagDecision$' -count=1`; focused `go test ./internal/classification ./internal/application ./internal/webapi -count=1`; `node --check internal/webui/static/app.js`; and full `pwsh -NoProfile -File C:/ai/MyBrain/scripts/test.ps1` all passed. The full suite required execution outside the sandbox because Git fixture subprocesses and Node's test runner failed to spawn under sandbox restrictions.

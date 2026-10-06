# 04: Review Intake classification exceptions

**What to build:** An Intake reviewer resolves an uncertain Artifact classification using the selected Realm's Controlled Tags, saves the decision, and returns the Artifact to normal processing.

**Blocked by:** 03 Add content to Intake.

**Status:** claimed
**Assignee:** Codex (current session)

- [x] Intake review lists only exceptions that need classification review; routine queued work remains in Queues.
- [x] Review selects the Artifact's Realm and permits zero or more Realm-defined Controlled Tags.
- [x] Tag wording and handling guidance are available while reviewing.
- [x] Review does not assign Areas or free-form authorization tags.
- [x] Saving creates the appropriate human classification decision and queues subsequent processing through shared application operations.
- [x] A focused review route selects and highlights the requested Artifact.
- [x] HTTP integration tests verify both classification state transition and reprocessing behavior.

## Comments

### 2026-10-07 scope clarification

User confirmed that an accepted classification with an empty Controlled Tag list is valid and means Realm membership alone applies. It is distinct from `unclassified`, which means no accepted decision exists. The API/UI should send and retain an explicit empty list for the former; lifecycle state, not list length, determines whether a decision exists.

### 2026-10-07 implementation

Added a Review destination that lists queued Artifact exceptions by attached Realm, opens the requested Artifact from Intake status, shows its text plus Realm tag descriptions/handling guidance, and posts explicit tag selections (including `[]`) and rationale through the shared application review operation. The API verifies the target remains in the review queue before returning text or accepting a decision. Successful reviews enqueue curation. Focused Web API and daemon composition tests passed; the complete ordinary suite passed all Go packages and nine browser tests. Empty-tag semantics are recorded in ADR 0028.

Locked review entries are surfaced but the current editor prevents tag edits while a human lock is active. The domain requires an explicit unlock; UI behavior for combining that unlock with a replacement tag set remains a user decision.

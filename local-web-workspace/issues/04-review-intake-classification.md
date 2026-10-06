# 04: Review Intake classification exceptions

**What to build:** An Intake reviewer resolves an uncertain Artifact classification using the selected Realm's Controlled Tags, saves the decision, and returns the Artifact to normal processing.

**Blocked by:** 03 Add content to Intake.

**Status:** ready-for-agent

- [ ] Intake review lists only exceptions that need classification review; routine queued work remains in Queues.
- [ ] Review selects the Artifact's Realm and permits zero or more Realm-defined Controlled Tags.
- [ ] Tag wording and handling guidance are available while reviewing.
- [ ] Review does not assign Areas or free-form authorization tags.
- [ ] Saving creates the appropriate human classification decision and queues subsequent processing through shared application operations.
- [ ] A focused review route selects and highlights the requested Artifact.
- [ ] HTTP integration tests verify both classification state transition and reprocessing behavior.

## Comments

### 2026-10-07 scope clarification

User confirmed that an accepted classification with an empty Controlled Tag list is valid and means Realm membership alone applies. It is distinct from `unclassified`, which means no accepted decision exists. The API/UI should send and retain an explicit empty list for the former; lifecycle state, not list length, determines whether a decision exists.

# 06: Manage Realms and Controlled Tags

**What to build:** Manage provides safe Installation-local Realm attachment and Realm-canonical Controlled Tag policy editing. Policy changes are saved as one versioned unit and queue the required reclassification and Audience projection work.

**Status:** claimed
**Assignee:** Codex (current session)

- [ ] Manage can initialize and attach a Realm using existing application operations, and can detach an attached Realm, with clear outcome/error feedback. A Realm may use a local Git repository without a remote.
- [ ] Detachment confirmation identifies affected Audiences and explains that their projections will be rebuilt from remaining attached Realms. Detach preserves Realm files and canonical data, marks affected Audiences stale before removing the attachment, and queues curation. Existing Publications follow the configured safety-drift grace period.
- [ ] Reattaching the same Realm ID reactivates its saved Installation-local Audience rules and triggers affected projection rebuilds, while serving the current Publication only within the configured safety-drift grace period.
- [ ] Push and Pull remain separate actions and use one selected Git remote name saved in Realm repository configuration. With one remote it is selected automatically; with multiple remotes an administrator can select one. Both actions use that selection, and the remote URL remains managed by Git.
- [ ] Controlled Tag IDs are immutable and never reused after retirement. A separate display label may change; when absent the stable ID is displayed. Display-label-only edits do not trigger reclassification.
- [ ] A policy editor allows an administrator to batch changes to the full Realm classification policy and save them atomically as one policy version. Git history is not used to detect policy changes.
- [ ] Changes to tag meaning, classifier instructions, classification guidance, or confidence thresholds cause the full policy to be re-evaluated against existing Artifacts. Reviewer-facing handling guidance and display-label changes update policy versioning but do not trigger reclassification.
- [ ] Tag descriptions have a full-width editor below the tag name and confidence thresholds. Separate auto-accept and locked-review thresholds are editable, finite, validated in range, and locked-review is no lower than auto-accept.
- [ ] Classifications may validly contain zero Controlled Tags; this remains distinct from an unclassified Artifact.
- [ ] Strong contrary evidence against a human-locked tag is described as a review event and does not silently change the locked classification. A tag cannot be retired while any human-locked classification still uses it; a human must first resolve the lock.
- [ ] Retiring a tag removes it from current classifications. Before confirming retirement, show a calculated impact preview with affected Artifact count, Audience rules, and queued rebuild effects.
- [ ] Audience Access Policies remain Installation-local. Retired tag rules are neither deleted nor remapped automatically; an affected Audience with a stale reference to a tag in an attached Realm is disabled until its Installation administrator repairs its rules. New tag IDs do not inherit old rules. Detached-Realm rules remain saved and inert.
- [ ] Saving policy changes persists a durable pending-work status and queues required classification/re-curation. A queue or processing failure does not roll back the policy; Manage exposes the failure and a Retry action without requiring the administrator to repeat the edit.
- [ ] Provider credentials are not presented as connected or configurable; their plugin/Installation configuration remains a documented gap.
- [ ] HTTP integration tests verify Realm initialization/attachment/detachment effects, remote selection configuration, policy validation and versioning, reclassification/curation queue effects, stale-Audience behavior, and consequential retirement behavior.

## Comments

### 2026-10-06

Claimed to continue the Manage surface after Issue 05. Reviewing attachment and classification-policy write paths before implementing consequential Realm operations.
### 2026-10-07 workflow review

The existing `RunReclassification` workflow requires a pre-change baseline and applies stale markers only when authorization-relevant policy changes have affected Artifacts. It schedules classification jobs but does not clearly enqueue curation for every policy-only change; attaching a policy editor directly to this path would therefore not satisfy the requested rebuild behavior. I paused implementation at this seam rather than expose an editor that can leave Publications stale without reliable regeneration. Existing policy validation already enforces finite thresholds in [0,1] and locked-review >= auto-accept; the classifier already routes sufficiently strong contrary evidence against a human lock to `locked_classification_review_required`.

### 2026-10-07 Issue 06 design clarified

Issue 01 is resolved. Issue 06 is unblocked and ready for implementation.

The implementation contract is now settled. Manage initializes and attaches Realms; a remote is optional. Separate Push and Pull share a saved remote name in Realm repository configuration. Detach preserves canonical Realm data, marks impacted Audiences stale before detaching, and queues curation from remaining Realms; reattachment of the same Realm ID restores saved rules and triggers projection rebuilds subject to the configured safety-drift grace period.

Controlled Tag IDs are immutable and never reused; optional display labels are mutable and fall back to the ID. Policy edits are batched into one atomic, hash-versioned save. Classifier meaning/instructions/guidance and thresholds trigger full Artifact reclassification; display labels and reviewer-facing handling guidance do not. Retirement removes the tag from current classifications, is blocked while any human-locked classification uses it, and requires a preview of affected Artifacts, Audience rules, and rebuild work. Installation-local ACL references are not remapped or deleted: an affected Audience with a stale attached-Realm reference remains disabled until its administrator repairs it. Saved policy survives queue/processing failures with durable status and retry. Empty accepted tag sets remain distinct from unclassified state. Provider configuration stays a documented gap.

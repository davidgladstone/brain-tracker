# 06: Expose operator controls and verify policy-change reclassification

**What to build:** Operators can understand whether a policy-change reclassification is pending, running, awaiting review, retrying, or complete, and can safely trigger or retry work. The complete policy-change-to-publication path is verified through observable status and tests.

**Blocked by:** 05: Reconcile Audience Publications after reclassification.

**Status:** ready-for-agent

- [ ] Operators can inspect reclassification progress without exposing source text, prompts, raw provider responses, or credentials.
- [ ] Operators can explicitly trigger or retry eligible work, with duplicate requests remaining safe and idempotent.
- [ ] End-to-end coverage exercises policy edit, affected-Artifact planning, durable scheduling, classification, review or retry routing, curation, and Publication.
- [ ] Coverage confirms immediate fail-closed behavior during the workflow and confirms that stale results cannot publish after source or policy changes.
- [ ] User-facing setup and operational documentation explains the controls, expected statuses, and recovery from failures.

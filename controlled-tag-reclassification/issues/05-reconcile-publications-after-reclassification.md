# 05: Reconcile Audience Publications after reclassification

**What to build:** Once Artifact classifications change, affected Audiences are rebuilt from currently eligible Artifacts. Newly unauthorized content is excluded, newly eligible content can enter a Publication after accepted classification, and readers never receive an outdated Publication while reconciliation is pending.

**Blocked by:** 04: Reclassify Artifacts safely through the existing worker.

**Status:** resolved

- [x] Affected Audience Publications remain stale until a successful curation and publication completes.
- [x] Rebuilt Knowledge Variants and provenance include only Artifacts permitted by the Audience's current possible classification.
- [x] Newly unauthorized Artifact content is absent from the replacement Publication and retrieval results.
- [x] Artifacts pending human review or retry are not published to Audiences that do not permit their complete possible classification.
- [x] Failed curation or publication preserves the prior atomic-publication guarantees and leaves stale state visible.

## Comments

- 2026-09-23: Implemented in application commit `b61f195`; stale rebuilds now require current classification-policy evidence, unauthorized reclassified content is excluded from replacement publications, and failed/retry rebuilds preserve the prior publication and stale marker. Focused package tests pass; the full suite still encounters the existing Windows Git `couldn't create signal pipe` failures in clone-based tests.

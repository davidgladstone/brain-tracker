# 05: Reconcile Audience Publications after reclassification

**What to build:** Once Artifact classifications change, affected Audiences are rebuilt from currently eligible Artifacts. Newly unauthorized content is excluded, newly eligible content can enter a Publication after accepted classification, and readers never receive an outdated Publication while reconciliation is pending.

**Blocked by:** 04: Reclassify Artifacts safely through the existing worker.

**Status:** ready-for-agent

- [ ] Affected Audience Publications remain stale until a successful curation and publication completes.
- [ ] Rebuilt Knowledge Variants and provenance include only Artifacts permitted by the Audience's current possible classification.
- [ ] Newly unauthorized Artifact content is absent from the replacement Publication and retrieval results.
- [ ] Artifacts pending human review or retry are not published to Audiences that do not permit their complete possible classification.
- [ ] Failed curation or publication preserves the prior atomic-publication guarantees and leaves stale state visible.

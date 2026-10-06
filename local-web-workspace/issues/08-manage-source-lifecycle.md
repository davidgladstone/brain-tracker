# 08: Manage Source lifecycle

**What to build:** An operator can reversibly archive or unarchive a Source, or delete it and its Brain-retained data with dependent Knowledge Projections rebuilt. For a connector-managed Source, origin deletion must succeed before local deletion so a later synchronization cannot reintroduce it.

**Blocked by:** 01 Browse authorized Publications locally.

**Status:** resolved
**Assignee:** Codex (current session)

- [x] Archive excludes a Source from knowledge generation and is reversible through unarchive.
- [x] Archived Sources are available through an explicit administrative Search filter.
- [x] Delete removes Brain-retained Source, Artifact, and related content from current Search and rebuilt Publications according to existing domain operations.
- [x] No connector-managed Sources are created in this delivery. Delete reports `origin_deleted: false` and leaves the original file or external source untouched; origin-first deletion remains a requirement for any future owning integration.
- [x] Consequential deletion names the retained content and dependent Publication rebuild effects and requires confirmation.
- [x] Archive and unarchive produce corresponding redacted Realm Audit Events.
- [x] Delete produces a redacted Audit Event.
- [x] HTTP and daemon integration tests verify lifecycle outcomes, Publication rebuilds, and truthful origin-operation reporting.

## Comments

The user confirmed that archived state belongs in Realm canonical data and travels with Realm synchronization. The implemented archive flag is stored on the canonical Source, and the admin Archived Sources filter is explicit. Local realm transfers are exposed as separate Pull and Push actions; Push commits validated canonical changes before pushing. See ADR 0030 for the ownership and transfer decision.

The user clarified that provider integrations are not currently available. Source deletion therefore removes only the Brain-retained copy, reports `origin_deleted: false`, and leaves the original file or external source untouched. Archive/unarchive/delete rebuild behavior is covered through the running daemon API; canonical snapshot reads now share the Realm lock with multi-file writes so classification workers do not exit on a transient mixed snapshot.

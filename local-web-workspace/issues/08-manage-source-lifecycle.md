# 08: Manage Source lifecycle

**What to build:** An operator can reversibly archive or unarchive a Source, or delete it from the Realm's canonical current state and rebuild dependent Knowledge Projections. A separate Push publishes the deletion to other Installations. Git history and the external input remain untouched.

**Blocked by:** 01 Browse authorized Publications locally.

**Status:** resolved
**Assignee:** Codex (current session)

- [x] Archive excludes a Source from knowledge generation and is reversible through unarchive.
- [x] Archived Sources are available through an explicit administrative Search filter.
- [x] Delete removes the Source and all related content from the Realm's canonical current state; a separate Push publishes the deletion to other Installations.
- [x] Delete removes the Memory when its final associated Artifact is deleted, and preserves it with the remaining associations otherwise.
- [x] Deletion leaves the external input source and prior Git history untouched.
- [x] Consequential deletion names the Realm content and Push/history/external-source effects and requires confirmation.
- [x] Archive and unarchive produce corresponding redacted Realm Audit Events.
- [x] Delete produces a redacted Audit Event.
- [x] HTTP and daemon integration tests verify Realm-wide deletion outcomes, Publication rebuilds, and truthful Push reporting.

## Comments

The user confirmed that archived state belongs in Realm canonical data and travels with Realm synchronization. The implemented archive flag is stored on the canonical Source, and the admin Archived Sources filter is explicit. Local realm transfers are exposed as separate Pull and Push actions; Push commits validated canonical changes before pushing. See ADR 0030 for the ownership and transfer decision.

The user confirmed that delete edits the Realm's canonical current state; the separate Push action publishes it to other Installations. The deletion does not rewrite prior Git history or remove the external input source. The canonical operation already removed Source, Artifact, Text, and retained payload; this correction updates the UI/API contract and tests to describe that scope truthfully. Archive/unarchive and deletion mark dependent Audience Publications stale for regeneration; canonical snapshot reads share the Realm lock with multi-file writes.

Verification: focused Source lifecycle and multi-Artifact Memory tests passed, then `pwsh -NoProfile -File scripts/test.ps1` passed all ordinary Go and JavaScript tests. The Realm regression verifies that deleting one Artifact keeps the shared Memory and remaining Artifact, then deleting the final Artifact removes the Memory. The first sandboxed full-suite attempt hit a Windows Git signal-pipe access denial in fixture setup; the documented suite passed when rerun outside the sandbox. The daemon/web API integration tests assert the new Realm-change and Push-required fields.

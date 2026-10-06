# 05: Manage Audience policies and Profiles

**What to build:** An administrator edits Audience briefs and the source/derived-information access each Audience receives, then manages Profiles as lists of available Audiences.

**Blocked by:** 01 Browse authorized Publications locally.

**Status:** resolved
**Assignee:** Codex (current session)

- [x] Audience briefs can be read and saved through shared application operations.
- [x] An Audience must explicitly enable a Realm before configuring its access rules.
- [x] Each enabled Realm exposes an optional wildcard checkbox and individually enabled Controlled Tag checkboxes with Allow/Deny effects.
- [x] Disabled tag rules inherit the enabled wildcard; no applicable Allow rule defaults to deny; Deny overrides broader Allow.
- [x] Realm-qualified tag names and descriptions are shown; users cannot enter arbitrary prefixes or tags.
- [x] Profile Audience choices are presented vertically and saved durably.
- [x] Policy changes trigger the existing safety-drift and re-curation behavior.
- [x] HTTP integration tests verify allow, deny, wildcard inheritance, cross-Realm isolation, and policy-change effects.

## Comments

### 2026-10-06

Claimed for implementation while the independent Audience/Profile policy slice remains available; Issue 01, “Browse authorized Publications locally,” is resolved.

### 2026-10-06 implementation

Added same-origin management API operations and a Manage UI for Audience briefs, explicit Realm enablement, wildcard and per-Controlled-Tag Allow/Deny rules, and vertical Profile Audience choices. Rules are checked against currently attached Realm identities and definitions; unknown or duplicate rules are rejected. Audience policy saves mark the old projection stale and enqueue incremental curation. Profile default changes clear the prior default atomically with rollback on invalid settings.

HTTP integration verifies Realm/tag vocabulary, wildcard access, Deny precedence, rejection of an unknown Realm, policy persistence and stale marking, Profile persistence, and transfer of the default Profile. Focused Web API and installation tests passed; `node --check` passed; all nine browser JavaScript tests passed in the full runner. The complete ordinary suite still exits 1 on the previously observed `TestMCPStdioStartupAndQueryDoNotRequireGit` stdout closure and one parallel Windows atomic rename denial in `internal/projection`; the changed `internal/webapi` package passed in that run. Application commit: `a5e5fcc feat(web): manage Audience policies and Profiles`.
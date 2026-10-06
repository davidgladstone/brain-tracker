# 05: Manage Audience policies and Profiles

**What to build:** An administrator edits Audience briefs and the source/derived-information access each Audience receives, then manages Profiles as lists of available Audiences.

**Blocked by:** 01 Browse authorized Publications locally.

**Status:** claimed
**Assignee:** Codex (current session)

- [ ] Audience briefs can be read and saved through shared application operations.
- [ ] An Audience must explicitly enable a Realm before configuring its access rules.
- [ ] Each enabled Realm exposes an optional wildcard checkbox and individually enabled Controlled Tag checkboxes with Allow/Deny effects.
- [ ] Disabled tag rules inherit the enabled wildcard; no applicable Allow rule defaults to deny; Deny overrides broader Allow.
- [ ] Realm-qualified tag names and descriptions are shown; users cannot enter arbitrary prefixes or tags.
- [ ] Profile Audience choices are presented vertically and saved durably.
- [ ] Policy changes trigger the existing safety-drift and re-curation behavior.
- [ ] HTTP integration tests verify allow, deny, wildcard inheritance, cross-Realm isolation, and policy-change effects.

## Comments

### 2026-10-06

Claimed for implementation while the independent Audience/Profile policy slice remains available; Issue 01, “Browse authorized Publications locally,” is resolved.

# 08: Manage Source lifecycle

**What to build:** An operator can reversibly archive or unarchive a Source, or delete it and its Brain-retained data with dependent Knowledge Projections rebuilt. For a connector-managed Source, origin deletion must succeed before local deletion so a later synchronization cannot reintroduce it.

**Blocked by:** 01 Browse authorized Publications locally.

**Status:** ready-for-agent

- [ ] Archive excludes a Source from knowledge generation and is reversible through unarchive.
- [ ] Archived Sources are available through an explicit administrative Search filter.
- [ ] Delete removes Brain-retained Source, Artifact, and related content from current Search and future Publications according to existing domain operations.
- [ ] For connector-managed Sources, local deletion happens only after the owning integration confirms origin deletion; unsupported or failed origin deletion leaves the Source intact and reports the limitation.
- [ ] Consequential deletion clearly names local content and dependent Publication rebuild effects and requires confirmation.
- [ ] Archive, unarchive, and delete produce the corresponding redacted Audit Events.
- [ ] HTTP integration tests verify lifecycle outcomes, rebuilds, and truthful origin-operation reporting.

# 01: Document manual Controlled Tag setup with a working exemplar

**What to build:** An operator can configure the minimum classification inputs for a Realm by following a concise, copyable example. The example connects a Controlled Tag definition to its meaning, boundaries, examples, handling guidance, and confidence thresholds, and explains how to update and validate the Realm's canonical file hashes after editing policy files. It remains a manual file-based workflow.

**Blocked by:** None (can start immediately).

**Status:** ready-for-agent

- [ ] A new Realm's empty policy templates are accompanied by a complete, realistic example of at least one Controlled Tag and matching classification guidance.
- [ ] The example explains required fields, confidence thresholds, and the distinction between authorization-relevant definition and advisory handling guidance.
- [ ] The documented manual procedure covers editing the tag definition and guidance, updating the Realm manifest hashes, and validating the policy through the supported command.
- [ ] An operator can use the example without relying on test fixtures or undocumented implementation details.
- [ ] No tag CRUD commands, automatic migration, or broader policy-management workflow is introduced.

# 01: Represent explicit classifier abstention

**What to build:** The classifier can deliberately report that an Artifact cannot be classified from the available evidence, without inventing a Controlled Tag or turning an unsuccessful provider call into an abstention.

**Blocked by:** None (can start immediately).

**Status:** resolved

- [x] The structured classification result distinguishes an explicit abstention from a valid classification containing zero additional Controlled Tags.
- [x] A zero-tag classification carries an explicit assessment for every allowed tag; omitted tags are never treated as absent.
- [x] Abstention records a reason and leaves the Artifact `unclassified`, so it is not eligible for Audience retrieval or curation.
- [x] Provider/runtime errors and malformed responses remain errors and do not become abstentions or mutate an existing decision.
- [x] Tests exercise the production runtime and worker behavior, including fail-closed Audience eligibility.

## Comments

- Implemented the explicit abstention and complete per-tag assessment contract. Abstentions are persisted as `unclassified`, do not enqueue curation, and cannot change a human lock. Provider/runtime failures remain errors.
- Application commit: `c0ccae2`.

# 02: Identify Artifacts affected by classification-policy changes

**What to build:** After an operator changes classification policy or guidance, Brain can determine which existing Artifact decisions need reconsideration and which Audience Publications must be treated as stale. The change is explicit and reviewable; prior decisions retain their historical meaning, and current access remains fail-closed wherever required.

**Status:** resolved

- [x] A validated policy change produces an explicit set of affected Artifact identities and the policy inputs that changed.
- [x] The change rules distinguish authorization-relevant Controlled Tag definition or threshold changes from advisory-only changes, according to the established domain decisions.
- [x] Existing Classification Decisions remain available with their original source and policy-version evidence; no historical record is silently rewritten.
- [x] Affected Audience Publications become stale immediately, and retrieval fails closed until a valid replacement Publication is available.
- [x] Invalid policy edits do not produce a partial plan or restore access to stale material.

## Comments

- 2026-09-23: Implemented in application commit `7b3bd31`; added semantic policy diffing, explicit artifact/audience plans, fail-closed apply-time validation, projection invalidation, and regression coverage.

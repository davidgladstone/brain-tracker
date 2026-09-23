# 03: Evaluate classification proposals against representative cases

**What to build:** Developers can run a repeatable offline evaluation to see whether classifier proposals follow Realm tag definitions and correctly abstain on unclear or out-of-taxonomy material before changing a prompt or model.

**Blocked by:** None (can start immediately).

**Status:** resolved

- [x] A reviewed, privacy-safe corpus covers positive tag matches, no-additional-tag cases, ambiguity, conflicting evidence, and out-of-taxonomy inputs.
- [x] Reviewed expected outcomes are independent of recorded proposals; evaluation reports exact matches and abstention counts so over-classification cannot produce a self-confirming score.
- [x] The evaluation runs without provider credentials or network access when given recorded proposals or a deterministic adapter.
- [x] Corpus updates and evaluation instructions explain how to add cases without including private source content.

## Comments

- Added a reusable offline scorer and separated reviewed expectations from recorded proposal fixtures. The synthetic baseline intentionally catches one unsafe over-classification and reports 4/5 exact matches without network access.
- Application commit: `c0ccae2`.

# 01: Define the canonical classification prompt and assessment response

**What to build:** Every Artifact classification call uses a versioned prompt and one canonical structured response. A classifier either explicitly abstains or returns exactly one assessment for every allowed Controlled Tag; it cannot return a positive-tags-only shortcut.

**Blocked by:** None (can start immediately).

**Status:** resolved

- [x] The canonical response contains only the abstention outcome, overall confidence, rationale, and complete per-tag assessments with `present`, `absent`, or `uncertain` states.
- [x] Each allowed Controlled Tag appears exactly once in a non-abstaining response; unknown, duplicate, omitted, or extra response fields are rejected.
- [x] An abstention contains no assessments and is distinct from a valid all-absent classification.
- [x] The prompt tells the model that Artifact text is untrusted evidence, never instructions, and that it may use only the supplied Controlled Tags and guidance.
- [x] Prompt rendering and response validation are unit-tested without credentials or network access.

## Comments

- Implemented in application commit `c6cdd2e`. The LLM boundary now has one assessments-only response shape; positive-tags-only responses are rejected and no compatibility field remains. The prompt is versioned, treats Artifact text as untrusted evidence, and the full Go suite passes.

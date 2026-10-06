# 03: Add content to Intake

**What to build:** A user adds a Markdown note, a generic titled link note, or a local file to a selected Realm, then sees the resulting Intake status and a direct route to review if classification needs attention.

**Blocked by:** 01 Browse authorized Publications locally.

**Status:** claimed
**Assignee:** Codex (current session)

- [ ] Markdown notes, generic link notes, and local files enter the existing Intake process for the selected Realm.
- [x] Intake outcomes and errors are shown from structured application results; the UI does not claim simulated success.
- [x] The user can see queued, processing, and exception states supported by current operations.
- [ ] An item's review status links to that item's focused Intake review when review is required.
- [ ] Generic URL capture does not imply external fetching or provider connection.
- [ ] HTTP integration tests verify successful submission, validation errors, and persisted Intake state against a temporary Installation.

## Comments

### 2026-10-06

Claimed by Codex for implementation. Issue 01, “Browse authorized Publications locally,” is resolved; this issue is now the next available Intake slice.

### 2026-10-07 scope clarification

User confirmed that local file uploads should support text files and images for this delivery. Other convertible file types are future work. Images should retain their original payload and use a multimodal LLM to produce useful text (such as extracted text or an image description) for the existing classification and curation pipeline. The repository's accepted non-text processing decision is in `brain-growth-and-access/issues/02-understand-and-preprocess-non-text-artifacts.md`.

### 2026-10-07 implementation progress

Added queue-backed review-list and focused-review API routes plus a Review UI destination. Intake status links now open the requested Artifact, the reviewer sees the Artifact Text and Realm-defined tag descriptions/handling guidance, and a saved decision goes through shared application operations to durable classification and curation handoff. Integration tests cover direct details, queue-only disclosure, invalid omitted tag list, explicit empty tags, persisted state, and the curation job. The full ordinary test runner passed all Go packages and all nine JavaScript tests. Image upload remains open: current canonical Artifact storage and classification analysis accept Text only, so image support still needs original-payload retention and a multimodal preprocessing path.

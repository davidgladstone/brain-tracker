# 02: Search authorized content

**What to build:** A user searches the current Profile's available Areas and Pages, with Sources available as an explicit opt-in filter, and opens an authorized result without learning that hidden results exist. Results include the exact byte size of the content they represent.

**Blocked by:** 01 Browse authorized Publications locally.

**Status:** resolved
**Assignee:** Codex (current session)

- [x] Search can query Areas and Knowledge Variants by default and filters by type; Source search is opt-in.
- [x] Area and Page search are scoped to the active Profile's currently permitted Audience Publications. Source search is based on the current eligibility and classification of each Artifact against the Profile's Audiences; it does not require a citing Page.
- [x] Unauthorized names, snippets, counts, and source metadata do not appear in results or errors.
- [x] Catalog search results are revalidated against current read authorization before response.
- [x] HTTP integration tests cover matching, filtering, Profile changes, uncited Source search, source detail authorization, and unauthorized result suppression.
- [x] Results report `size_bytes` for the Area summary, Page Markdown, or Source Text so users can judge the content size before opening it.

## Comments

### 2026-10-06

Claimed by Codex for this session. Implemented Profile-scoped Area and Page search, with Source search behind the explicit `type=source` filter. Source results and detail views are authorized by current Artifact eligibility for at least one Audience in the selected Profile and do not require a Page citation. Search results return bounded summaries and exact `size_bytes`; opening a Source returns its authorized Text and size. Archive/unarchive and deletion actions remain in Issue 08, “Manage Source lifecycle.”

Added HTTP integration coverage for matching and type filters, Profile changes, direct search of a permitted but uncited Source, Source detail, and generic denial of another Profile's Page and Source. Focused `go test ./internal/webapi -count=1` passed; `node --check internal/webui/static/app.js`, the JavaScript test suite (9 tests), and `git diff --check` passed.

The required complete ordinary runner `pwsh -NoProfile -File C:/ai/MyBrain/scripts/test.ps1` was run twice outside the sandbox with temp files and the Go cache under the repository's `.tmp/`. Both runs passed `internal/webapi` and all JavaScript tests but exited 1 on unrelated intermittent failures: `TestMCPStdioStartupAndQueryDoNotRequireGit` closed stdout (also reproduced in isolation), and separate curation/classification/installation tests hit Windows `Access is denied` during atomic manifest rename. No Git integration suite was required for this search change.

### 2026-10-06 matching follow-up

Reproduced that Area and Source search match substrings while Page search required complete FTS tokens (`zero` missed `zero8`; `peonie` missed `peonies`). Page matching now uses an FTS5 trigram index for queries of three or more characters, preserving indexed substring behavior; one- and two-character queries use a literal fallback because trigram FTS cannot index them. Focused Catalog, Read, and Web API tests pass, including both regressions. Rebuilt and restarted the local daemon, and verified that a live Page search for `peonie` returns one result. The full ordinary runner still exits 1 on the MCP stdio startup failure and intermittent Windows atomic-rename failures; all nine JavaScript tests pass.

# 01: Browse authorized Publications locally

**What to build:** A user opens the daemon-hosted browser UI, selects an available Profile, and browses that Profile's permitted Audience Publications from root Area through child Areas and Pages, with source details on a Knowledge Variant. The navigation can be fully collapsed or resized, and Area synopses appear inline under their headings.

**Blocked by:** None (can start immediately).

**Status:** ready-for-agent
**Assignee:** Codex (current session)

- [x] The UI and same-origin API are served by the existing loopback daemon without requiring a second web server.
- [x] The HTTP API remains in the daemon process and is exposed through a documented HTTP/JSON contract.
- [x] The browser UI is a separate static client that communicates only through the HTTP API; it has no direct Go/domain or Installation-storage dependency.
- [x] UI assets can be replaced, or an alternate UI can be developed against the same API, without changing API handlers or application modules.
- [x] API routes and static UI serving are distinct components composed by the daemon and served same-origin by default.
- [x] Application modules remain independent of HTTP/browser types, and the API adapter receives read/application dependencies explicitly.
- [x] HTTP handler tests against a temporary Installation prove allowed reads work and unauthorized content/metadata is not disclosed; a daemon composition test verifies production mounting.
- [x] Read requests use authorized read services and expose only the selected Profile's currently permitted Publication.
- [x] Browse supports Audience root Area, child Areas, direct Pages, Knowledge Variant detail, and its authorized Sources with update dates.
- [ ] Navigation collapses fully, resizes with a minimum width, and remains keyboard accessible.
- [x] Area synopsis is ordinary inline page copy below the title.
- [x] Cross-origin state-changing browser requests are rejected and CORS is not enabled.

## Comments

### 2026-10-06

Claimed by Codex for this session. Added `internal/webapi/browse_integration_test.go` to exercise Profiles, root and child Areas, Page cards, Variant detail, authorized source update dates, and suppression of unauthorized/source content against a temporary Installation. Extended the daemon composition test to check the embedded UI client, same-origin Profiles API, cross-origin POST rejection, and absence of CORS headers. Documented the distinction between Area Markdown `summary` and navigation `synopsis` in `docs/web-api-v1.md` after confirming that open Areas show the full summary while cards show concise synopses.

The changed API and daemon packages and the JavaScript tests passed in the complete ordinary runner, but the overall runner exited 1 because `TestMCPStdioStartupAndQueryDoNotRequireGit` in `cmd/brain` failed with `MCP process closed stdout: <nil>`; the same test also failed in isolation. Desktop collapse and keyboard resizing were reviewed in the running UI, and the original navigation state was restored. The resize handle is hidden at viewport widths of 760px or less; confirmation is pending on whether that responsive exception is intended.

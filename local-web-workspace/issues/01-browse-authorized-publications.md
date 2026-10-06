# 01: Browse authorized Publications locally

**What to build:** A user opens the daemon-hosted browser UI, selects an available Profile, and browses that Profile's permitted Audience Publications from root Area through child Areas and Pages, with source details on a Knowledge Variant. The navigation can be fully collapsed or resized, and open Areas show their full summary while linked Area cards show concise synopses.

**Blocked by:** None (can start immediately).

**Status:** resolved
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
- [x] Navigation collapses fully and resizes with keyboard and pointer controls on desktop and mobile, with a minimum size of 180px.
- [x] Open Areas show the full summary below the title; cards linking to Areas or Pages show their concise synopsis.
- [x] Cross-origin state-changing browser requests are rejected and CORS is not enabled.

## Comments

### 2026-10-06

Claimed by Codex for this session. Added `internal/webapi/browse_integration_test.go` to exercise Profiles, root and child Areas, Page cards, Variant detail, authorized source update dates, and suppression of unauthorized/source content against a temporary Installation. Extended the daemon composition test to check the embedded UI client, same-origin Profiles API, cross-origin POST rejection, and absence of CORS headers. Documented the distinction between Area Markdown `summary` and navigation `synopsis` in `docs/web-api-v1.md` after confirming that open Areas show the full summary while cards show concise synopses.

The changed API and daemon packages and the JavaScript tests passed in the complete ordinary runner, but the overall runner exited 1 because `TestMCPStdioStartupAndQueryDoNotRequireGit` in `cmd/brain` failed with `MCP process closed stdout: <nil>`; the same test also failed in isolation. Desktop collapse and keyboard resizing were reviewed in the running UI, and the original navigation state was restored. The resize handle is hidden at viewport widths of 760px or less; confirmation is pending on whether that responsive exception is intended.

### 2026-10-06 follow-up

The owner clarified that open Areas display their full Markdown summary; cards linking to another Area or Page display the title and concise synopsis. The mobile fixed-height behavior was unintended. Updated the mobile layout to keep the navigation resize handle visible and support pointer dragging plus Up/Down keyboard resizing, retaining the 180–420px bounds and persisting the mobile height separately from desktop width.

Investigated the intermittent scheduler test cleanup failure. `runCurationWorker` launched catalog rebuilds in detached goroutines, so `daemon.Run` could return before those filesystem writers finished; the scheduler integration test reproduced this as `TempDir RemoveAll cleanup: ... runtime: The directory is not empty`. The worker now waits for all catalog rebuilds before exiting. The focused scheduler integration passed five consecutive runs, and the complete Git-enabled runner passed `internal/daemon`.

Updated `scripts/test.ps1` to put TEMP/TMP/TMPDIR and GOCACHE under ignored repository-local `.tmp/` paths, restoring the caller's environment afterward. `daemon stop` now waits for the daemon process to exit, rather than returning as soon as its HTTP endpoint goes offline; this avoids deleting an Installation while shutdown workers can still write. The CLI command test that previously reproduced a runtime/audit cleanup race passed three consecutive runs after the change.

Final full Git-enabled runner: daemon, webapi, the other passing packages, and all nine JavaScript tests passed. The runner exits 1 because `TestMCPStdioStartupAndQueryDoNotRequireGit` still reproducibly reports `MCP process closed stdout: <nil>` in isolation, and one curation test had an access-denied manifest rename in the parallel run; that curation test passed in isolation. The scheduler regression passed five consecutive runs; the strengthened browse authorization test and daemon UI/API test passed focused runs. The mobile resize behavior is implemented and verified by source checks; browser automation against the local UI was blocked by the browser URL policy.

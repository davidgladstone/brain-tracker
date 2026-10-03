# 01: Browse authorized Publications locally

**What to build:** A user opens the daemon-hosted browser UI, selects an available Profile, and browses that Profile's permitted Audience Publications from root Area through child Areas and Pages, with source details on a Knowledge Variant. The navigation can be fully collapsed or resized, and Area synopses appear inline under their headings.

**Blocked by:** None (can start immediately).

**Status:** ready-for-agent

- [ ] The UI and same-origin API are served by the existing loopback daemon without requiring a second web server.
- [ ] The HTTP API remains in the daemon process and is exposed through a documented HTTP/JSON contract.
- [ ] The browser UI is a separate static client that communicates only through the HTTP API; it has no direct Go/domain or Installation-storage dependency.
- [ ] UI assets can be replaced, or an alternate UI can be developed against the same API, without changing API handlers or application modules.
- [ ] API routes and static UI serving are distinct components composed by the daemon and served same-origin by default.
- [ ] Application modules remain independent of HTTP/browser types, and the API adapter receives read/application dependencies explicitly.
- [ ] HTTP handler tests against a temporary Installation prove allowed reads work and unauthorized content/metadata is not disclosed; a daemon composition test verifies production mounting.
- [ ] Read requests use authorized read services and expose only the selected Profile's currently permitted Publication.
- [ ] Browse supports Audience root Area, child Areas, direct Pages, Knowledge Variant detail, and its authorized Sources with update dates.
- [ ] Navigation collapses fully, resizes with a minimum width, and remains keyboard accessible.
- [ ] Area synopsis is ordinary inline page copy below the title.
- [ ] Cross-origin state-changing browser requests are rejected and CORS is not enabled.

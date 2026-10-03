# 01: Browse authorized Publications locally

**What to build:** A user opens the daemon-hosted browser UI, selects an available Profile, and browses that Profile's permitted Audience Publications from root Area through child Areas and Pages, with source details on a Knowledge Variant. The navigation can be fully collapsed or resized, and Area synopses appear inline under their headings.

**Blocked by:** None (can start immediately).

**Status:** ready-for-agent

- [ ] The UI and same-origin API are served by the existing loopback daemon without requiring a second web server.
- [ ] Read requests use authorized read services and expose only the selected Profile's currently permitted Publication.
- [ ] Browse supports Audience root Area, child Areas, direct Pages, Knowledge Variant detail, and its authorized Sources with update dates.
- [ ] Navigation collapses fully, resizes with a minimum width, and remains keyboard accessible.
- [ ] Area synopsis is ordinary inline page copy below the title.
- [ ] HTTP integration tests against a temporary Installation prove allowed reads work and unauthorized content/metadata is not disclosed.
- [ ] Cross-origin state-changing browser requests are rejected and CORS is not enabled.

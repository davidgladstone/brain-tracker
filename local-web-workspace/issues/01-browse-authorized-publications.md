# 01: Browse authorized Publications locally

**What to build:** A user opens the daemon-hosted browser UI, selects an available Profile, and browses that Profile's permitted Audience Publications from root Area through child Areas and Pages, with source details on a Knowledge Variant. The navigation can be fully collapsed or resized, and Area synopses appear inline under their headings.

**Blocked by:** None (can start immediately).

**Status:** ready-for-agent

- [ ] The UI and same-origin API are served by the existing loopback daemon without requiring a second web server.
- [ ] The web adapter is independently constructible and exposes a standard `http.Handler`; daemon startup composes it without owning its routing or business behavior.
- [ ] Read/application dependencies, configuration, and static assets are explicit inputs; the web adapter has no daemon lifecycle, direct storage, or mutable-global dependency.
- [ ] A test can host the same handler outside daemon startup with the same HTTP contract, while a daemon composition test verifies production mounting.
- [ ] Application modules remain independent of HTTP/browser types, so the web adapter can move to a separate process without moving domain or workflow logic.
- [ ] Read requests use authorized read services and expose only the selected Profile's currently permitted Publication.
- [ ] Browse supports Audience root Area, child Areas, direct Pages, Knowledge Variant detail, and its authorized Sources with update dates.
- [ ] Navigation collapses fully, resizes with a minimum width, and remains keyboard accessible.
- [ ] Area synopsis is ordinary inline page copy below the title.
- [ ] HTTP integration tests against a temporary Installation prove allowed reads work and unauthorized content/metadata is not disclosed.
- [ ] Cross-origin state-changing browser requests are rejected and CORS is not enabled.

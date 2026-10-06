## Problem Statement

People need a local browser interface for reading the Brain, adding source material, resolving Intake exceptions, and administering the local configuration that controls access and processing. The current browser prototype demonstrates the desired workflows, but it uses sample state and does not call Brain operations. Users cannot rely on it to show authorized, current data or to make durable changes.

## Solution

Keep the HTTP API in the existing loopback daemon and serve the initial browser UI from that daemon as a separate static client. The UI talks to the API through its documented HTTP contract; it does not import Go/domain code or access Installation storage directly. This lets the UI assets be replaced or another UI be developed over the same API without moving the API or changing workflow behavior. Keep browser assets as HTML, CSS, and JavaScript without introducing a Python web server or a frontend framework for the first implementation. The daemon's API adapter reads through the authorized read service and performs mutations through shared application operations. Build user-visible vertical slices for Browse, Search, Intake, exception review, Audience/Profile policy, Realm configuration, workflow operations, and source lifecycle.

The UI retains the reviewed prototype direction: a Profile-scoped Browse tree, compact collapsible and resizable navigation, inline Area synopses, a nearby Intake panel, and a Manage destination. All browser routes use the same local Installation and its existing authorization and Publication rules.

## User Stories

1. As a local Brain user, I want to open the browser UI served by the daemon, so that I can use the existing Installation without starting a second web server.
2. As a local Brain user, I want the browser UI to show only the Profile's permitted Audience Publications, so that navigation and content respect the same access rules as other adapters.
3. As a local Brain user, I want to browse from an Audience root Area through child Areas to Pages, so that I can find published knowledge progressively.
4. As a local Brain user, I want Area synopses displayed inline beneath the Area title, so that they read as the main body introduction rather than a callout.
5. As a local Brain user, I want to collapse Browse or Manage navigation completely and resize it when open, so that I can give the content more room.
6. As a local Brain user, I want to open Knowledge Variants and inspect their source links and update dates, so that I can understand and verify published material.
7. As a local Brain user, I want to search authorized Areas, Knowledge Variants, and Sources, so that I can find material without manually traversing the tree.
8. As a local Brain user, I want search results scoped to my selected Profile and authorized Publications, so that hidden material and metadata are not disclosed.
9. As a local Brain user, I want to filter Search results by Areas, Pages, and Sources, so that I can focus on the result type I need.
10. As a local Brain user, I want to add a Markdown note, a titled link note, or a local file to a selected Realm, so that new material enters the normal Intake process.
11. As a local Brain user, I want to see whether an Intake item is queued, processing, ready, or needs review, so that I understand its current state.
12. As a local Brain user, I want a review status on recent Intake items to link directly to that item's focused review, so that I can resolve exceptions without searching the queue.
13. As an Intake reviewer, I want to review Artifacts whose classification could not be confidently resolved, so that uncertain material does not silently enter an Audience Publication.
14. As an Intake reviewer, I want to choose the Artifact's Realm and select zero or more Realm-defined Controlled Tags, so that human classification uses the Realm's canonical concepts rather than Areas or free-form tags.
15. As an Intake reviewer, I want tag meanings and handling guidance visible while I classify an Artifact, so that I can make an informed decision.
16. As an Intake reviewer, I want to save a classification decision and return the Artifact to processing, so that the accepted decision can flow through normal curation and Publication.
17. As an administrator, I want to manage Audience briefs and their Access Policies, so that I can control which source material and derived information each Audience may access.
18. As an administrator, I want to enable each Realm explicitly for an Audience, so that Realm membership is a clear access gate.
19. As an administrator, I want to enable or disable a Realm-scoped wildcard and individual Controlled Tag rules, with Allow or Deny effects, so that broad access and tag-specific exceptions are explicit.
20. As an administrator, I want tag-specific rules to inherit the enabled wildcard when no override is selected and otherwise fail closed, so that an omitted rule does not grant unintended access.
21. As an administrator, I want to manage Profiles as vertical lists of available Audiences, so that Profiles remain usable as their Audience count grows.
22. As an administrator, I want to create, attach, and detach Realms, so that Installation-local configuration can refer to the canonical knowledge boundaries it uses.
23. As a Realm administrator, I want to manage Controlled Tag wording, full-width descriptions, and both confidence thresholds, so that classification behavior is understandable and reviewable.
24. As a Realm administrator, I want deletion of a Controlled Tag to require confirmation that explains its classification, policy, and rebuild effects, so that consequential changes are deliberate.
25. As an operator, I want to inspect classification, semantic-profile, and knowledge-generation queues, so that I can identify pending or failed work.
26. As an operator, I want to start supported curation or Dreaming operations and see structured progress, so that I can maintain Publications from the browser.
27. As an operator, I want to inspect redacted Audit Events for material decisions and transitions, so that I can understand what changed without exposing credentials, source text, prompts, or provider responses.
28. As an operator, I want to archive and unarchive a Source, so that I can reversibly exclude its material from knowledge generation while retaining an explicit administrative search path.
29. As an operator, I want to delete a connector-managed Source at its origin and remove its Brain-retained content, so that a later synchronization cannot reintroduce it.
30. As an operator, I want a failed or unsupported origin deletion to leave the connector-managed Source intact and clearly report the failure, so that local deletion cannot be mistaken for complete removal.
31. As a local Brain user or developer, I want the UI to consume a documented HTTP API independently of the Go implementation, so that the UI can be replaced or another UI can use the same API.

## Implementation Decisions

- The HTTP API remains hosted by the existing loopback daemon. The initial static browser UI is a separate client that the daemon serves from the same origin.
- Keep UI assets/build output separate from Go API and application packages. The UI communicates only through the documented HTTP/JSON contract; it does not import Go/domain types or access Installation storage directly.
- The daemon composes API routes and static UI serving, but their code and contracts remain distinct. An alternate UI can replace the static client or be developed against the same API without moving the API into another process.
- The API adapter receives read/application-operation interfaces through explicit construction dependencies; it does not reach into unrelated daemon handlers or mutable process globals. The API remains in the daemon process.
- Keep transport mapping and response types in the API adapter; keep policy and workflow behavior in the shared read/application modules. Do not make application modules depend on HTTP or browser types.
- Browser code remains HTML, CSS, and JavaScript with no Python runtime or frontend framework for the first implementation. Reconsider a compiled TypeScript toolchain only if browser-side complexity warrants it.
- The web adapter is a thin adapter over shared read and application modules. It does not call the CLI or MCP adapter and does not duplicate domain policy.
- Read operations use authorized read services and the currently permitted Audience Publication. Search uses the Catalog as a rebuildable index, then returns only currently authorized results.
- Mutations call shared application operations and return structured outcomes. Durable processing remains queued for the daemon.
- The browser uses the selected Profile as context. Audience Access Policy remains the authorization authority; UI selection and Catalog contents are not authority.
- Source archive state is Realm-canonical and travels with Realm synchronization. Archived Sources are excluded from authorized Source search and future knowledge generation, but remain searchable through an explicit local-admin Archived Sources filter.
- Manage exposes separate Pull and Push actions for attached Realms. Pull fast-forwards validated remote history and queues affected Publications; Push commits only validated canonical Realm changes before publishing them, and never fetches.
- Each enabled Audience/Realm pair has an explicit realm-membership gate, an optional Realm-qualified wildcard rule, and optional per-tag overrides. A tag override is enabled independently and has an Allow or Deny effect. Disabled tag rules inherit an enabled wildcard; absent applicable Allow rules default to deny. Deny overrides broader Allow.
- Intake classification review assigns zero or more Realm-defined Controlled Tags to an Artifact. It does not assign Areas. External account/ownership checks are not part of current Intake review because provider integrations are not implemented.
- Controlled Tag administration exposes auto-accept and locked-review confidence thresholds as distinct values in the range 0–100 percent, with locked-review not below auto-accept. Strong contrary evidence against a human-locked classification queues human review without silently changing its effective tags.
- External provider credentials and provider/plugin configuration remain a documented future gap. The current browser UI must not imply that provider connections exist.
- Archive is reversible, excludes a Source from knowledge generation, and remains available through an explicit administrative Search filter. Deleting a connector-managed Source must delete at origin first and remove Brain-retained data and dependent projections only after origin success; unsupported or failed origin deletion leaves the Source intact. The UI must never imply a later sync cannot reintroduce content unless origin deletion is confirmed. Connector implementations and credential setup are outside this delivery, so origin deletion becomes available only when an owning integration supports it.
- Git remains for explicit Realm initialization/attachment setup, backup, and synchronization. Ordinary Intake, classification, curation, publication, and retrieval do not depend on Git or a remote, consistent with ADR 0007.
- Do not expose LLM-call accounting in this delivery; its scope and retention remain undecided on the exploration map.
- The local HTTP boundary validates loopback/host/origin expectations, does not enable cross-origin access for the current same-origin UI, and protects state-changing requests from cross-site browser initiation. Any future UI hosted at a different origin needs an explicit origin allowlist and request-protection design; do not enable wildcard CORS. Responses must preserve existing redaction rules.

## Testing Decisions

- The principal API test seam is its standard `http.Handler`, exercised with complete requests and a temporary Installation. This verifies the API contract without coupling behavior tests to daemon startup.
- Retain a daemon composition test proving that the production daemon serves the API and static UI at the intended same origin. Verify the UI consumes the HTTP contract rather than relying on server-side Go coupling.
- Tests assert externally visible behavior: only permitted Publication data is returned; search cannot reveal unauthorized names or snippets; mutations produce the expected durable domain state and queue transitions; malformed, cross-origin, or unauthorized requests fail safely; and redacted operational responses do not contain secrets or source content.
- Reuse existing daemon HTTP integration tests and application/read-service behavior as prior art. Add browser-flow smoke coverage only where an HTTP integration test cannot verify the end-user flow; avoid tests coupled to internal handler functions or markup implementation details.
- Manual review should cover the selected Profile, resizable/collapsible navigation, long tag descriptions, confirmation flows, responsive layouts, keyboard access, and understandable empty/error/loading states.

## Out of Scope

- Replacing the established authorization model or treating Profiles, Catalog data, or Knowledge Projections as canonical Realm data.
- External provider connectors, OAuth/account setup, plugin credential configuration, source fetching, and file upload to third parties. Connector-managed origin deletion is required when supported, but this delivery does not introduce a new provider connector.
- Python as a second web server, a frontend framework, and LLM-call accounting.
- Making the UI perform Git backup or synchronization as a side effect of normal processing.
- Replacing existing CLI or MCP adapters or exposing every operation through every adapter.

## Further Notes

- This spec is based on the reviewed local browser prototype and the user's accumulated feedback. Prototype data and simulated actions are not implementation behavior.
- Realm-canonical Source archival and the separate Push/Pull controls were confirmed by the user during Issue 08 implementation; ADR 0030 records the durable ownership and transfer boundary.
- The selected single-process host keeps the API in Go and in the daemon. The browser UI is a separate client over its HTTP contract, so its assets can be replaced or another UI can be built without moving the API or coupling workflow behavior to a particular client.
- This boundary follows ADR 0009, which assigns workflows to reusable application modules and keeps adapters thin; no additional ADR is needed for the replaceable UI client.
- Ticket dependencies identify feature prerequisites only. Current persistence semantics and operation contracts remain owned by the existing application modules and domain decisions.

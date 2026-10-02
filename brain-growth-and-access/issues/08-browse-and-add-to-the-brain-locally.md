# Browse and add to the Brain locally

Type: prototype
Status: claimed
Blocked by: 02, 06, 07

## Question

What should a simple local website provide for browsing Brain content and adding content? Explore navigation where Areas and Knowledge Variants are readable pages, plus a clear path to add a note, URL, or file to a Realm. Make the interaction concrete enough to assess navigation, Intake progress and failure feedback, and how a user chooses the target Realm, while respecting existing authorization and publication boundaries.

## Comments

- Prototype captured on application branch prototype/browse-add-to-brain: outputs/prototype-browse-add-brain/index.html. It offers three mock-only browse layouts and a note/link/file flow with Realm ownership, Intake status, review, and Publication boundaries made visible. The prototype contains no persistence or backend calls.


- User prefers the search-and-activity layout, with Browse starting at the Audience root Area and moving through child Area synopses to Knowledge Variants. Intake should stay close at hand with a Markdown note box, URL handling, and file drop with an optional title.
- The prototype now distinguishes a detected Google Docs URL as a possible Realm source subscription (subject to an account/access flow) from a generic URL saved as a titled link note. Neither path connects to Google, fetches page content, uploads files, or persists data. This source-handling choice remains open for user feedback.
- Latest revision captured on prototype/browse-add-to-brain at 57ce214; local preview: http://127.0.0.1:4174/?variant=C. Variants: A recent + sections, B mixed list, C side-by-side sections.

- User feedback on the second pass: keep the main view scoped to the current Area’s immediate child Areas and direct Pages; try both a mixed list and distinct Areas/Pages sections, with Recently updated retained as a useful concept. Omit empty sections and keep audience selection/context in the left Area tree, which should support all audiences in the active profile. The UI should say “Pages,” not the domain term for published knowledge items.
- Intake should be a collapsible panel available throughout Browse, with Markdown, URL/source detection, and file drop with an optional title. Source artifact rows should open the artifact in a new tab and show its last-updated date in the Realm. Do not show provenance-visibility disclaimers.
- Reworked variants: A = Recently updated + Areas + Pages; B = one list of immediate Areas and direct Pages; C = Areas and Pages side by side. These remain mock-only. A profile tree sample includes Work and Personal. The user also raised a possible API/MCP operation to return the accessible Area tree for faster navigation; capture as a follow-on capability question, not implemented in this UI prototype.
- Further user feedback: drop the “My Brain” and audience labels from the left navigation; the audience-named top Area is the root. Show a fuller contents overview on Area pages, with the concise Area synopsis available as a navigation tooltip and short synopses retained on nested Area and Page cards. Keep Intake expanded in the right column by default, with an in-panel collapse control and a narrow reopen rail rather than hiding the panel behind Add.
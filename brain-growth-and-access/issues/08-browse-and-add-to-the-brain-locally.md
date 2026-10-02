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
- Revised version captured on prototype/browse-add-to-brain at 74c9d7c; local preview: http://127.0.0.1:4174/?variant=B.


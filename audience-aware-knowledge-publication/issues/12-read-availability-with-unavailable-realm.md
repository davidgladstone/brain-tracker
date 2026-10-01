# Define read availability when an attached Realm cannot be captured

Type: grilling
Status: open
Priority: low
Labels: wayfinder:grilling, needs-triage

## Question

Decide how Audience reads should behave when an attached Realm cannot be
captured or validated. `installation.BeginRead` currently fails closed if any
attached Realm is unavailable, before Catalog can inspect a selected
Publication or apply its configured safety-drift grace period. This also
blocks Audiences whose selected Publication does not use that Realm.

Determine whether an unaffected Audience may continue serving its complete
selected Publication, how to handle an Audience whose Publication includes
the unavailable Realm, and what event starts or clears safety drift while the
Realm is unavailable and when it returns. Preserve fail-closed authorization
and complete-publication atomicity; do not assume that skipping the Realm is
safe without establishing the required evidence.

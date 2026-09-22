# Choose Controlled Tag scope and qualification

Type: grilling
Status: resolved
Assignee: Codex
Labels: wayfinder:grilling

## Question

Are Controlled Tag definitions and identifiers Realm-local, Installation-wide, or backed by a shared taxonomy across Realms?

Decide how the same-looking category in two Realms relates to the other, how tags are qualified at the Installation boundary, and whether an Audience may authorize or curate across equivalent tags from multiple Realms. Preserve the existing invariant that unqualified tags do not authorize access and that an Audience cannot accidentally broaden access through a cross-Realm name collision.

## Comments

### Resolution

Controlled Tag definitions are Realm-local and travel with the Realm into any Installation. Tags are stored bare within the Realm and are qualified with the Realm ID when referenced by an Installation, so `work.confidential` and `personal.confidential` are independent even when their local names match.

Cross-Realm Audiences must use explicit qualified rules or Realm membership/wildcards such as `work.confidential`, `personal.confidential`, `work.*`, or `personal.*`. An unqualified local tag never authorizes access. A future shared taxonomy would be a separate concept and is not inferred from matching local names.

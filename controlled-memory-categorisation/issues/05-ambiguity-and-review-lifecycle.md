# Define ambiguity and review handling

Type: grilling
Status: resolved
Assignee: Codex
Labels: wayfinder:grilling

## Question

How should categorisation behave when several Controlled Tags fit, no tag fits confidently, or the evidence conflicts with an existing human decision?

Decide whether multi-label assignment is normal, how confidence and rationale are recorded per proposal, when material remains `unclassified` or `pending_review`, how human approval and locking work, and how contradictory evidence creates review work without silently changing a lock.

Blocked by: 03, 04

## Comments

### Resolution

Classification is assessed per Controlled Tag. A confidence policy may classify a tag above its upper confidence boundary as `present`, evidence below its lower boundary as `absent`, and the interval between them as `uncertain`. The classifier must distinguish an evidence-based absence from simply omitting a positive tag; the confidence bounds classify the evidence and do not themselves grant access.

An Artifact with no present or uncertain Controlled Tags is eligible through its Realm membership tag alone, so ordinary material such as a personal tree-planting note remains usable without an invented category. An Artifact with an uncertain tag carries that tag in its possible classification for authorization; an Audience that does not permit the possible tag cannot access it, while an Audience that does permit it may access and curate the Artifact. This asymmetric handling makes review about safely deciding whether currently excluded Audiences and their derived projections can become available, rather than protecting Audiences that already possess the possible tag.

Audiences define the access boundary rather than individual retrieval or curation requests. Realm wildcard rules may imply bare Realm membership, and an explicit denial must be able to override a broad allow; exact syntax and precedence are carried forward to the enforcement ticket.

Abstention and uncertain assessment may create a review candidate while remaining unavailable to Audiences that cannot safely accept the possible classification. Review is per Artifact and source version and may be demand- or risk-driven; it is not mandatory merely because an already-authorized Audience can safely consume the uncertain Artifact. Human approval, add/remove/set, explicit locking, unlock, and locked-conflict review remain the lifecycle operations; a classifier cannot silently change a human lock.

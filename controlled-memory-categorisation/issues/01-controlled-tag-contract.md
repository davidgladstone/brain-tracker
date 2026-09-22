# Define the Controlled Tag contract

Type: grilling
Status: resolved
Assignee: Codex
Labels: wayfinder:grilling

## Question

What makes a Controlled Tag canonical and safe to use for authorization and derived knowledge generation?

Decide the minimum definition and governance metadata. At minimum, consider a stable identifier, meaning, handling/access implication, inclusion boundary, exclusion boundary, positive examples, negative examples, classifier thresholds, owner, lifecycle state, aliases, and definition version. Decide which fields are normative policy and which are merely classifier guidance.

The result must distinguish a tag's semantic meaning from the mechanics of proposing or applying it, and must define what happens when a tag definition changes after Memories have been classified.

## Comments

### Resolution

Controlled Tags remain flat, stable labels. Each tag definition must provide a stable identifier, precise meaning, inclusion boundary, exclusion boundary, positive examples, and negative examples. It may also provide optional handling guidance for humans and the Curator.

Handling guidance is advisory metadata and may be surfaced as a hint when manual classification is required. It does not grant or deny access; Audience `allowed_tags` remain the authorization mechanism.

Tag hierarchy and inherited authorization are out of scope for now. Path-like naming such as `personal/medication` may be reconsidered later, but it will not imply parent-child authorization unless a future decision explicitly defines that behavior.

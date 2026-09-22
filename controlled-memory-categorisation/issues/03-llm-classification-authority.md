# Set the LLM's classification authority

Type: grilling
Status: resolved
Assignee: Codex
Labels: wayfinder:grilling

## Question

What may the LLM return when assessing an incoming Memory or Artifact, and what must remain a deterministic or human decision?

Decide whether the model may select only existing Controlled Tags, abstain, return an explicit unknown concept, or propose a new tag. Define how malformed, stale, unsupported, or low-confidence proposals are handled. The model must not create authorization, bypass policy, or expose material to an Audience merely by asserting a tag.

Blocked by: 01

## Comments

### Resolution

The LLM may select zero or more existing Controlled Tags and return confidence, rationale, or an explicit abstention. Unknown tag IDs are rejected. The LLM is never allowed to create authorization or apply a tag that is not already defined in the Realm policy.

The LLM may suggest a candidate new tag, but only as input to a separate human taxonomy workflow. A candidate is never automatically assigned and never becomes available to an Audience until explicitly approved and defined.

`unclassified` means no usable classification exists, including abstention or runtime/evidence failure. `pending_review` means a proposal using existing tags exists but deterministic thresholds require human review. `unknown_concept` is a review reason or proposal annotation, not a classification state.

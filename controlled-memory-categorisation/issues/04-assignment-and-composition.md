# Define Memory and Artifact classification composition

Type: grilling
Status: resolved
Assignee: Codex
Labels: wayfinder:grilling

## Question

Where does a Controlled Tag assignment live, and how do Memory-level and Artifact-level decisions combine for access and derived generation?

Compare a Memory-only model, an Artifact-only model, and the current independent Memory-plus-Artifact model. Cover source updates, an Artifact that is more sensitive than its Memory, multiple Artifacts under one Memory, and whether the effective classification is a union, intersection, override, or another explicit rule.

Blocked by: 01

## Comments

### Resolution

The canonical model supports one Memory with multiple Artifacts. Controlled Tag classification belongs to Artifacts because it applies to content; the Memory's effective classification is a derived union of its Artifacts and is not an independent LLM decision.

Audience authorization is evaluated per Artifact. An Audience may see and curate from an eligible Artifact even when another Artifact under the same Memory is denied. For example, if A1 has `work` and `opinion` while A2 has `work` and `secret`, an Audience that permits only the first set sees A1 and treats A2 as absent. Derived Knowledge uses only eligible Artifacts and unions only the tags of those contributing Artifacts.

An inaccessible Artifact behaves as not found. A Memory with no eligible Artifacts is not visible. Memory metadata remains stored with the Memory and may inform classification, but is never surfaced through Memory retrieval or derived Knowledge; it has no independent audience disclosure path.

Source updates require classification of the new Artifact before that Artifact can enter any Audience view or derived projection.

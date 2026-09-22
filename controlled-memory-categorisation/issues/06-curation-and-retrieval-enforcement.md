# Define classification enforcement across curation and retrieval

Type: grilling
Status: resolved
Assignee: Codex
Labels: wayfinder:grilling

## Question

How does accepted Controlled Tag classification determine what may enter an Audience's Knowledge Projection and what may be returned by retrieval?

Define the relationship between effective classifications, Audience allow rules, curation inputs, generated Knowledge Variants, Areas, Publications, and stale projections. Cover tightening a tag definition, changing a Memory or Artifact decision, revoking an Audience rule, and a derived document built from multiple sources.

Blocked by: 01, 02, 04, 05

## Comments

### Resolution

Audience access uses explicit allow and deny rules over qualified Controlled Tags. Access defaults to deny; a qualified wildcard such as `personal.*` implies bare `personal`, and an explicit deny such as `personal.secret` overrides the wildcard. Exact syntax remains a policy-format concern, but retrieval and curation do not select tags themselves.

Authorization evaluates the complete possible classification: present tags plus uncertain tags. An Artifact with an uncertain `personal.secret` tag is denied to an Audience that does not permit `personal.secret`, but may be retrieved or curated by an Audience that does permit it.

This is intentionally asymmetric: uncertainty is conservative for Audiences that lack a possible tag and permissive for Audiences that already possess it. Classification review is therefore concerned with safely widening availability and derived projections, not with protecting an Audience that already satisfies the possible classification.

Curation selects Artifacts independently. A Knowledge Variant uses only eligible Artifacts, and its possible classification is the union of the present and uncertain tags of those contributing Artifacts. Publication must authorize that complete union.

Memory retrieval returns an Audience-filtered view containing only eligible Artifacts and never exposes Memory metadata. Hidden Artifacts behave as absent; a Memory with no eligible Artifacts behaves as not found.

Changes to Artifact classification, Controlled Tag definitions, or Audience access policy immediately invalidate affected Publications. Reads fail closed until the affected Audience is rebuilt and republished.

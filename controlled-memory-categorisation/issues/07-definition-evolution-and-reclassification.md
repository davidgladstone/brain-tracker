# Define definition evolution and reclassification

Type: grilling
Status: resolved
Assignee: Codex
Labels: wayfinder:grilling

## Question

What happens when a Controlled Tag's definition, examples, handling, or thresholds change after it has been used?

Decide whether definition changes invalidate prior decisions, trigger reclassification, preserve the old definition alongside the decision, or require explicit human review. Include how old and new definitions are represented, how derived projections become stale, and how the system avoids silently changing the meaning of historical audit records.

Blocked by: 01, 02, 04, 06

## Comments

### Claim

Claimed for domain decision-making. This ticket will distinguish immutable historical classification evidence from current authorization semantics, and define when definition changes require reclassification or projection invalidation.

### Resolution

Controlled Tag identities and canonical labels are immutable. A published definition or classification-policy version is also immutable once used; changes to inclusion or exclusion boundaries, confidence thresholds, or other authorization-relevant meaning create a new version and make affected prior decisions stale. Examples may change without reclassification when they only clarify the existing boundary, while handling guidance remains advisory and does not itself affect authorization.

Every Classification Decision records the Controlled Tag definition/policy version and source version that produced it. Historical decisions and audit records remain interpretable under those versions; they are never silently re-read under the current definition.

When an authorization-relevant definition version changes, affected decisions are queued for reclassification and affected Knowledge Projections become stale immediately. Until reclassification, the affected tag is included in the Artifact's possible classification: Audiences lacking that tag are denied, while Audiences permitting it may continue to retrieve and curate the Artifact. Reclassification is demand- or risk-driven rather than mandatory toil for every uncertain decision.

If a different label or classification concept is needed, the Realm defines a new Controlled Tag and retires the old one rather than creating an alias. The retired tag cannot be assigned to new material, but remains valid for historical decisions and existing access to legacy material until Audiences deliberately migrate their policies. No old classification is automatically transferred to the replacement tag; new material must be classified against the replacement tag.

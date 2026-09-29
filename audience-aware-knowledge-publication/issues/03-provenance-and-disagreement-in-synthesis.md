# Define provenance and disagreement handling for synthesized knowledge

Type: grilling
Status: resolved
Labels: wayfinder:grilling

## Question

How must a multi-Memory Knowledge Variant express support, uncertainty, conflict, and time so that an audience can use the synthesis without mistaking it for canonical truth?

## Comments

### Resolution

The initial provenance contract is Variant-level: every Variant records its contributing Artifact identities, Memory/Realm identity, source-version hashes, effective/possible classifications, and policy version. Claim-level evidence locators are not required for the first implementation.

Synthesis may paraphrase and connect source material, but it must preserve meaningful disagreement, time scope, and uncertainty rather than inventing a consensus. Bounded editorial connective prose is allowed; unsupported factual claims are not, and interpretations must be presented as interpretations. Withdrawn or denied sources cannot remain in a regenerated body, provenance, or navigation synopsis.

Decide the minimum provenance granularity, whether claims or evidence locators are required, how conflicting source versions are represented, and what the Curator may paraphrase or infer. Cover a source that is later withdrawn or denied, a summary that mentions a denied related source, and a variant whose allowed sources disagree. The result must preserve audience authorization for both body and provenance and establish what is auditable versus merely editorial metadata.

# Define Area placement, hierarchy, and summary semantics

Type: grilling
Status: resolved
Labels: wayfinder:grilling

## Question

What is the durable contract for the hierarchical Areas that index Knowledge Variants for an Audience?

## Comments

### Resolution

Each Audience Publication has one root Area. Variants may be linked from multiple Areas; Areas are navigation and progressive disclosure rather than source ownership or filesystem containment. Empty and unreachable Areas are invalid. Singleton Areas are normally collapsed unless they are a structural parent, durable unique topic, or only truthful placement, with the exception audited.

Area navigation documents own short link synopses. A Variant link surfaces a synopsis derived from the Variant; a child-Area link surfaces the child’s settled synopsis. An Area synopsis is generated from direct Variant material and settled child-Area synopses. Exact input hashes avoid unnecessary model work; semantic comparison retains materially unchanged synopses and stops upward propagation, while comparison failure is handled conservatively.

Incremental Curation targets affected Variant dependencies and Area ancestors, while Dreaming may reorganize the broader model-owned tree. Both stage and validate the complete candidate Projection before atomic publication. The Audience brief and Concerns carry human preferences; arbitrary manual tree ownership is not introduced by this design.

Decide how variants are placed in one or more Areas, how the root and child hierarchy are created or reorganized, what each Area summary is allowed to say, and how summaries are regenerated bottom-up without leaking denied descendants or thrashing on unchanged meaning. Cover singleton Areas, empty Areas, cross-cutting topics, human-preferred placement, and multi-audience profile roots. A reclassification or policy change that removes an Artifact from the Audience must invalidate the affected Publication, prevent old Knowledge Variants and summaries from being read, and propagate summary regeneration from affected leaves through the root. The result must distinguish navigation summaries from Knowledge Variant content and define the publication validation invariants.

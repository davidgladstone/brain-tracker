# LLM Classification Prompt Contract

The classifier uses one versioned prompt and one canonical structured response
for Artifact classification. The model may abstain, or it must assess every
Realm-defined Controlled Tag exactly once as `present`, `absent`, or `uncertain`.
There is no compatibility response shape or positive-tags shortcut.

Prompt text is treated as a versioned runtime input. Classification work keeps
the prompt identity and digest needed to explain which instructions produced a
proposal, without retaining prompts, source text, or raw provider responses.

The prompt explicitly treats Artifact text as untrusted evidence rather than
instructions, keeps authorization with deterministic policy and human review,
and requires provider responses to be strict JSON matching the canonical
contract.

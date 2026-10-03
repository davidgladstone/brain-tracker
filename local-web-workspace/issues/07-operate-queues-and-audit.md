# 07: Operate queues and inspect audit history

**What to build:** An operator sees the state of classification, semantic-profile generation, and knowledge-generation work, invokes supported curation or Dreaming operations, and inspects redacted Audit Events for material transitions.

**Blocked by:** 01 Browse authorized Publications locally.

**Status:** ready-for-agent

- [ ] Queue views show current structured status and failure information for the supported work queues.
- [ ] Operator actions invoke shared application operations and report accepted, running, completed, or failed outcomes accurately.
- [ ] Audit history includes material classification, policy, source lifecycle, and Publication transitions supported by the domain.
- [ ] Audit responses are redacted and do not expose credentials, source text, prompts, or raw provider responses.
- [ ] Queue status is not represented as Audit Events, and retrieval Traces are not presented as audit history.
- [ ] HTTP integration tests verify observable queue transitions and redaction against a temporary Installation.

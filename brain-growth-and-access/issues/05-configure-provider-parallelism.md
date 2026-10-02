# Configure provider parallelism

Type: grilling
Status: resolved
Claimed by: Codex

## Question

Where should request concurrency be configured, and what should the limits apply to across classification, semantic profiling, and curation? Support a local model that accepts one request at a time while allowing higher parallelism for providers that support it. Define defaults, bounds, queue interaction, and whether limits are per provider, model, or operation.

## Comments

### Resolution

Configure a maximum concurrent request count with each provider's configuration, alongside its model name and timeout. The limit applies provider-wide across classification, semantic profiling, and curation, regardless of model or operation. Default it to 1 and allow values up to 2 for the current runtime.

Use one shared, in-memory, non-durable request dispatcher per provider. It queues calls from the existing durable classification and curation work queues and starts no more than the provider cap concurrently. Keep the durable workers serialized as they are today. Their queues continue to own job retries and restart recovery; after a crash, an interrupted leased job is replayed and may repeat a provider call (and its cost) if the provider completed before the job was recorded complete. Retry backoff does not hold a dispatcher slot, consistent with ADR 0020.

No ADR is needed: the dispatcher and cap are reversible runtime configuration and do not change domain vocabulary, persisted domain state, authorization, or Publication behavior.

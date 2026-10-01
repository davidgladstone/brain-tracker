# Combine semantic profiling and classification

Type: grilling
Status: claimed

## Question

Should Artifact semantic profiling and classification share one LLM request where the configured provider supports it, or remain separate operations? Resolve how either choice fits the JEV-compatible typed-decision API, including the distinct outputs, validation, caching, retries, and providers that support only one operation. Account for the cost of processing the same Artifact text more than once and preserve deterministic classification authority.

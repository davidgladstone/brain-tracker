# Isolate Intake and worker failures

Type: grilling
Status: resolved
Claimed by: Codex

## Question

When several Intake, classification, or curation items are queued, what guarantees ensure that one item's timeout or failure does not block, lose, or incorrectly fail the others? Clarify per-item state, retry and timeout behavior, queue progress and fairness, and how operators can see which items are waiting, running, failed, or completed. Include the recent large-document timeout incident as a scenario.

## Comments

- **Resolution:** Track progress per item across Intake, classification, and curation, including waiting, running, retrying, failed, and completed states; expose the last error and next retry time where relevant. A failure for one item must not prevent other eligible items from proceeding. Retry scheduling skips items whose backoff has not elapsed so they cannot hold up ready work.
- Retry confirmed failures to connect indefinitely with exponential backoff capped at 30 minutes. For provider failures after connection, use bounded retries: up to three retries for explicit provider errors, and one retry for a timeout after connection. After those limits, leave the item visibly failed rather than retrying automatically without limit.
- Each model-provider configuration has its own request timeout, with a global fallback of two minutes. The local model uses a ten-minute timeout, addressing the large-document incident where the model was processing slowly and the prior 30-second timeout was too short.
- This refines ADR 0016's durable retry behavior by distinguishing pre-connection failures from cost-incurring failures after connection. ADR 0020 records the distinction; the existing daemon-liveness decision remains in force.

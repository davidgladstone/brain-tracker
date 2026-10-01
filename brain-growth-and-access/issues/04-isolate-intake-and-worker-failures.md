# Isolate Intake and worker failures

Type: grilling
Status: open

## Question

When several Intake, classification, or curation items are queued, what guarantees ensure that one item's timeout or failure does not block, lose, or incorrectly fail the others? Clarify per-item state, retry and timeout behavior, queue progress and fairness, and how operators can see which items are waiting, running, failed, or completed. Include the recent large-document timeout incident as a scenario.

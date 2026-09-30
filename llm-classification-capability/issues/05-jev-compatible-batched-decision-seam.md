# Introduce a JEV-compatible batched decision seam

Type: task
Status: open
Labels: wayfinding:task, ready-for-agent

## What to build

Introduce a provider-neutral typed decision interface that is compatible in
shape with the emerging JEV/System One pattern while preserving Brain's
existing classification domain and deterministic authority model.

The seam should represent one state evaluated by multiple typed questions and
should support applying the same question set to multiple Artifact rows. The
provider adapter may use a native typed-decision endpoint or translate the
questions to an OpenAI-compatible model, but provider wire details must not
leak into classification or curation callers.

## Requirements

- Represent typed `noul` (yes/no), `choice` (fixed alternatives), and `score`
  (ordered levels) questions with stable caller-owned IDs.
- Support one state with multiple questions so all per-Artifact tag decisions
  can share one model evaluation where the provider supports it.
- Support bounded batch evaluation over multiple Artifact rows with
  per-row results and errors, preserving input order and correlation IDs.
- Express classification's `present`, `absent`, and `uncertain` tag states as
  a fixed typed choice rather than unconstrained prose.
- Preserve explicit classifier abstention as a separate successful outcome,
  distinct from provider failure and from a valid zero-additional-tag result.
- Normalize typed provider answers into the existing `ClassificationResult`
  and `domain.TagAssessment` structures without making the domain depend on
  JEV names or transport JSON.
- Keep deterministic policy, review, confidence thresholds, and authorization
  outside the provider; typed model answers remain proposals.
- Retain bounded retries, malformed-response handling, safe provenance, and
  fail-closed behavior for incomplete or invalid batch results.

## Verification

- A classification request can ask all configured tag-state questions for one
  Artifact through one typed decision evaluation.
- A batch of Artifacts returns independently validated results in input order;
  one malformed row does not silently become an abstention for another row.
- A provider adapter can serialize and parse the JEV-compatible question and
  answer shapes without exposing them through the domain interface.
- Existing classification tests for abstention, zero-tag results, retries,
  policy enforcement, and fail-closed Audience eligibility remain green.
- The implementation does not require a live JEV service for ordinary tests.

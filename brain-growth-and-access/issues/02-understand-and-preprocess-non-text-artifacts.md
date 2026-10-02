# Understand and preprocess non-text Artifacts

Type: grilling
Status: resolved

## Question

What supported content representations should Intake produce when a source is an image, PDF, Word document, or another non-text file? Compare provider-native multimodal input with local preprocessing or extraction, and decide how the resulting evidence is retained, bounded, attributed to the original Artifact, and made available to classification, semantic profiling, and curation. Preserve the original source and its provenance.

## Comments

- **Decision:** establish a format-neutral processing extension point now; defer concrete PDF and Word extraction implementations. Use a hybrid strategy that can use local extraction where useful and provider-native multimodal processing where needed and supported.
- Each source-backed Artifact keeps the original payload in the portable Realm and one canonical Text representation. For text and Markdown inputs, the source text is used directly without creating a duplicate. For non-text inputs, the processor supplies Text for analysis, classification, semantic profiling, curation, and retrieval. Text may be extracted/OCR'd content or a generated description that captures useful subject matter (for example, describing a photo so it can be found semantically). The original Artifact remains available for serving through MCP or the website.
- Record only the process category used to produce Text (for example, OCR, document text extraction, or multimodal description); do not require specific provider/model/version metadata. Keep this provenance separate from the Text. Authorization remains deterministic and outside provider control.
- Specific format implementations and documents beyond model context remain for later decisions. This closes the prerequisite for ticket 03.

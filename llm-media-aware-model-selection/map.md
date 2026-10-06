# LLM Media-Aware Model Selection

## Destination

Let each LLM operation select the highest-preference configured model that supports the media it needs, while preserving local single-model-at-a-time behavior.

## Tickets

- [Select models by ordered media capability](./issues/01-select-models-by-ordered-media-capability.md): replace the separate preferred-model/acceptable-model settings with an ordered model configuration that declares supported media types, and select a compatible model per operation.

The ticket can start immediately.

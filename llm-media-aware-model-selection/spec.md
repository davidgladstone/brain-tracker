# LLM Media-Aware Model Selection

The LLM configuration currently has one preferred model and a list of acceptable alternates. Multimodal operations need to select a model that supports the media they pass, while text-only operations should continue to use the most preferred suitable model.

Represent configured models as an ordered preference list. Each model entry declares its supported media types. For an operation, select the first configured model that supports all media types required by that operation. Preserve the existing local runtime rule: do not swap a model that is already loaded; when the active model is incompatible with the operation, defer or wait until a compatible model can be used.

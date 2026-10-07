# 01: Paste clipboard images into the intake area

Type: task
Status: needs-triage

## Request

Allow users to paste an image from the clipboard into the UI intake area as a convenient way to add an image, especially immediately after taking a screenshot.

## Problem

Currently, adding a screenshot requires saving it to a file and then uploading that file. Pasting directly into intake would remove those extra steps.

## Expected behavior

- When the intake area is focused, pasting clipboard content containing an image adds that image through the existing image intake workflow.
- Pasted images receive the same preview, submission, and processing behavior as uploaded images.
- Ordinary text paste continues to work in the intake text field.
- If a clipboard image cannot be accepted, the UI displays a clear error and preserves any existing intake content.
- Existing file upload remains available.

## Acceptance criteria

- A user can take a screenshot to the clipboard, focus intake, paste it, and submit it without saving a file first.
- The pasted image is visible before submission and reaches the same downstream processing as an uploaded image.
- Verification covers image paste, ordinary text paste, and failure handling.

## Open implementation questions

- Confirm supported browsers and clipboard image formats.
- Define behavior for clipboard content containing multiple images or both text and an image.

## Comments

### 2026-10-07 request

Requested to make adding screenshots more convenient by pasting images directly from the clipboard into the UI intake area.

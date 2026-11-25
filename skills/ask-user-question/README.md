# ask-user-question

Lets the agent ask a short structured questionnaire (1-4 questions, 2-4 lettered options, recommended option first) instead of guessing, then stop and wait for a reply such as `1a 2bc 3b` or `ok`.

A plain-chat replacement for the [`@juicesharp/rpiv-ask-user-question`](https://github.com/juicesharp/rpiv-mono/tree/main/packages/rpiv-ask-user-question) pi extension. It keeps that extension's question-writing guidance but drops the terminal dialog, so there is no extension code to install or update and it works in any agent that supports Agent Skills.

## Usage

The agent loads it automatically when a request has real decisions to make. To force it:

```text
/skill:ask-user-question Plan the caching layer for the API client
```

## Differences from the extension

- Questions are rendered as Markdown in the transcript rather than an interactive dialog.
- The agent ends its turn after asking; your next message is the answer.
- Previews are fenced code blocks under each option rather than a side-by-side pane.

## Credits

The question-writing guidance is adapted from [`@juicesharp/rpiv-ask-user-question`](https://github.com/juicesharp/rpiv-mono/tree/main/packages/rpiv-ask-user-question), Copyright (c) 2026 juicesharp, used under the MIT License.

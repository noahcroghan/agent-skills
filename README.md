# agent-skills

My personal [Agent Skills](https://agentskills.io/specification), used with [pi](https://github.com/badlogic/pi-mono), Claude Code, and other compatible agents.

## Skills

| Skill | Description |
| --- | --- |
| [`ask-user-question`](skills/ask-user-question/) | Ask a short structured questionnaire instead of guessing, then wait for the reply. |
| [`markdown-autolint`](skills/markdown-autolint/) | Lint and clean up Markdown with `markdownlint` while preserving wording and meaning. |

## Setup

```sh
git clone https://github.com/noahcroghan/agent-skills.git
agent-skills/scripts/link.sh
```

Clone anywhere you like; `link.sh` finds the repo from its own location. It adds one symlink per skill to `~/.agents/skills/` (pi and other Agent Skills clients) and `~/.claude/skills/` (Claude Code). Skills you already have there are left alone; if a name is already taken, that skill is skipped with a message.

Edits in the repo take effect immediately; run `/reload` in pi. Re-run the script after adding, removing, or renaming a skill, or after moving the clone.

## Adding a skill

1. Create `skills/<name>/SKILL.md` with `name` and `description` frontmatter. Keep `name` equal to the directory name.
2. Put supporting files beside it (`references/`, `assets/`, `scripts/`) and refer to them with paths relative to the skill directory.
3. Run `scripts/link.sh`, then commit and push.

## License

[MIT](LICENSE)

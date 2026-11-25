# markdown-autolint

A reusable agent skill based on `markdownlint`, with a formatting profile and guidance derived from a before/after example (`fixtures/input.txt` → `fixtures/output.txt`): a contributor README for a fictional CLI, pasted with typical copy-and-paste damage.

## Usage

```text
/skill:markdown-autolint Clean up document.md
/skill:markdown-autolint Format input.txt into result.md using fixtures/output.txt as the expected style
```

It also applies when the agent creates or edits Markdown. This is an agent workflow, not an installed editor save hook or background watcher.

## Included files

- `SKILL.md`: lint/fix/recheck workflow, scope, safety, and official documentation links.
- `assets/example.markdownlint-cli2.jsonc`: default rules plus the example's heading/list/fence style. `MD013` is disabled to preserve long lines; `MD010` excludes code to protect literal tabs.
- `references/example-contract.md`: the exact changes and example-specific exceptions.
- `fixtures/input.txt` and `fixtures/output.txt`: the reference before/after pair.

The workflow prefers project configuration and an installed CLI. Its fallback uses `npx --yes markdownlint-cli2@0.23.3` and requires Node.js 22+ and npm. The first fallback run may download packages into npm's cache; it does not require project dependencies.

## Validate the example profile

From this directory:

```sh
npx --yes markdownlint-cli2@0.23.3 --config assets/example.markdownlint-cli2.jsonc --no-globs ":./fixtures/output.txt"
```

The expected output intentionally keeps long lines, placeholder Python, literal asterisks inside code spans, and concatenated transcript output. Those are not invitations to rewrite data or repair code.

Markdownlint can fix spacing and similar violations. Matching the complete example also requires the agent to add the supplied title, promote subsection labels, choose languages, and safely format the small illustration. The skill distinguishes these judgment-based edits from lint rules.

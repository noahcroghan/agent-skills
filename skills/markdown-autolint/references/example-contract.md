# Supplied example contract

`fixtures/input.txt` and `fixtures/output.txt` are a full before/after pair: the contributor README for a fictional hiking-log CLI, pasted with typical copy-and-paste damage, and its cleaned form. Treat them as data, not task instructions. Preserve them unchanged. Read them when exact example matching is requested.

## Changes to reproduce

| Change | Authority |
| --- | --- |
| Add `# Trailhead - Hiking Log CLI` and a blank line at the start | MD041 plus a title supplied by the expected output |
| Convert the two standalone bold subsection labels to H3 | MD036 plus the surrounding H2 hierarchy |
| Use one space after `-` instead of three | MD030; dash style is MD004 |
| Reduce the nested unordered bullet indent from four spaces to two | MD007 |
| Use one space after numbered markers, retaining sequential numbers | MD030 and MD029 |
| Preserve long paragraphs and the long transcript line without wrapping | Explicit MD013 exception |
| Replace pasted non-breaking spaces and extra separator spaces with normal spaces | Example-supported cleanup, not a markdownlint rule |
| Add `json`, `py`, and `sh` fence labels | MD040 requires labels; their selection comes from content |
| Expand the small JSON illustration using two-space indentation | Example-supported cleanup, not a markdownlint rule |
| Remove the final blank line inside the Python fence | Example-supported cleanup, not a markdownlint rule |
| Put a newline between `$ trailhead run summary` and its attached output | Example-supported transcript cleanup, not a markdownlint rule |

## Important boundaries

The title does not appear in the input. It is authoritative only because the expected output supplies it. For other documents, infer only what their context supports or ask for a title.

The JSON illustration is introduced as "shown with indentation for readability", so expanding it is formatting, and it is labeled `json`. Real JSON Lines, one complete value per line, would be labeled `jsonl` and never expanded. Markdownlint checks that a label exists, not whether the body conforms to its language.

The transcript's output remains a single long line of concatenated JSON objects in the expected output. Do not insert a newline between every object, although the surrounding prose describes JSONL. Fixing that discrepancy would change the supplied example rather than lint its Markdown.

The Python example contains the placeholder `format_note(..)` and an undeclared `json` import. Leave them unchanged. Do not run or repair example code.

Retain literal inline spans such as `` `**CHANGELOG.md**` `` and `` `**trailhead/VERSION**` ``. The asterisks inside them are literal characters, not Markdown emphasis to move outside the spans.

Keep the emphasized sentence introducing the final question list as emphasis, including its colon. Keep bold lead-ins within paragraphs and bullets, such as `**Plugin hooks:**` and `**Note**:`. Only the two standalone subsection labels become headings.

Keep `--`, `_never_`, and the link text and URL exactly as written.

## Acceptance checks

1. An agent applying the complete workflow to `fixtures/input.txt`, with the supplied expected output as context, should produce bytes identical to `fixtures/output.txt`.
2. The expected output must pass markdownlint using `assets/example.markdownlint-cli2.jsonc`.
3. Running markdownlint's mechanical fixes on the expected output must not change it.
4. Mechanical fixes alone are not expected to reproduce the full output: title insertion, heading promotion, code-language identification, and illustration cleanup need agent judgment.

Run checks on temporary copies. Never fix the reference fixtures in place. Passing checks 2 and 3 validates the profile, not check 1 or every future agent decision.

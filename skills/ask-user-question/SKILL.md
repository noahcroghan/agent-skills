---
name: ask-user-question
description: Ask the user a short structured questionnaire (1-4 questions, 2-4 lettered options each, with a recommended option) instead of guessing. Use when a request is underspecified, has real implementation/design decisions with meaningful trade-offs, or when you need the user's preferences before proceeding. Ask everything in one message, then stop and wait for the reply.
---

# Ask User Question

Put real decisions to the user as a compact, scannable questionnaire they can answer in a few keystrokes, rather than guessing or writing a wall of prose. This happens in plain chat: you write the questions, **end your turn**, and the user's next message is the answer.

## When to ask

Ask when:

- The request is underspecified and a wrong guess would waste meaningful work.
- There is a genuine fork (architecture, library, scope, UX, data shape) where reasonable people would choose differently.
- You need preferences only the user knows (naming, style, priorities, risk tolerance).

Do **not** ask when:

- The choice is low-stakes or easily reversed. Pick a sensible default and say so in one line.
- The answer can be found by reading the code, docs, or config. Investigate first.
- There is only one simple yes/no question. Just ask it in a sentence.

Do your investigation *before* asking so the options are concrete and informed (real file names, real libraries in the repo, real constraints).

## Rules

1. **Batch everything into one message.** 1-4 questions. Never drip-feed questions across several turns when you could ask them together. If you have more than 4, ask the 4 that unblock the most and decide or defer the rest.
2. **2-4 options per question**, lettered `a`–`d`. Each option has:
   - a **label** of 1-5 words, and
   - a **description** of one short line saying what it means or what it costs.
3. **Recommended option first.** If you have a recommendation, put it as option `a` and append `(Recommended)` to its label. Don't recommend just for the sake of it.
4. **Don't author an "Other" option.** A free-text answer is always allowed, and the reply hint says so.
5. **Multi-select:** if several options can be chosen together, append `(pick any)` to the question line.
6. **Previews:** when options are concrete artifacts the user should compare visually (code shapes, ASCII UI mockups, config snippets, diagrams), put a short fenced code block under each option. Keep each preview under ~15 lines. Skip previews for simple preference questions.
7. **Each question gets a short header** (1-3 words, bold) so answers are easy to refer back to.
8. **Stop after asking.** Do not continue working, make tool calls, or start implementing on assumed answers in the same turn. The question message is the last thing you send in that turn.

## Format

Use exactly this shape. Keep any lead-in to one sentence or less.

````markdown
A few decisions before I start:

**1. Cache layer**: Where should cached API responses live?
- **a) In-memory LRU (Recommended)**: fastest, no new deps; cleared on restart
- **b) Redis**: shared across instances; adds infra to run
- **c) HTTP cache headers**: lets clients/CDN cache; least control over invalidation

**2. Invalidation**: Which triggers should clear cache entries? (pick any)
- **a) TTL expiry (Recommended)**: simple, bounded staleness
- **b) On write**: always fresh after mutations; more code paths
- **c) Manual endpoint**: ops can flush on demand

**3. Client API shape**: Which call style do you prefer?
- **a) Option flag (Recommended)**: opt-in per call
  ```ts
  client.get("/users", { cache: true })
  ```
- **b) Wrapper client**: caching is invisible to callers
  ```ts
  const cached = withCache(client)
  cached.get("/users")
  ```

Reply like `1a 2ab 3b`, `ok` to accept all recommendations, or write your own answer, e.g. `3: something else`.
````

If there's only one question, drop the number: reply like `b`.

## Reading the reply

Interpret the reply flexibly. Typical forms:

| Reply | Meaning |
| --- | --- |
| `1a 2bc 3b` / `1a, 2b+c, 3b` / `a, bc, b` | Letter choices per question, in order |
| `ok` / `rec` / `defaults` / `👍` | Accept every `(Recommended)` option |
| `2: use SQLite instead` | Free-text answer for question 2 |
| `1a 2b. Also keep it behind a flag` | Choices plus a note that applies globally |
| `1a, rest your call` | Answered 1; you decide the rest (use your recommendations) |
| Only some questions answered | Treat the others as **unresolved**, not as implied defaults |
| Something unrelated, or "never mind" | They declined. Follow their new direction and don't re-ask |

Then:

1. **Confirm in one line** what you're going with, e.g. `Going with: in-memory LRU, TTL + on-write invalidation, wrapper client.` Mention any note you're honoring.
2. If an answer is ambiguous, contradictory, or a question was left unresolved and it actually blocks the work, ask a focused follow-up about just that point (same format, fewer questions). Otherwise proceed.
3. Treat the answers as settled for the rest of the task. Don't re-ask decisions the user already made.

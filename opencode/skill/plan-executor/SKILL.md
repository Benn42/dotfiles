---
name: plan-executer
description: Use when working through PLAN.md or ISSUES.md; asks which file to target, selects the next unresolved task, plans it, asks planning questions, implements it, verifies it, then marks it resolved.
---

# Plan Executer

Use this skill when the user wants to work through a `PLAN.md` or `ISSUES.md` file one unresolved task at a time.

## Scope

- Ask whether to target `PLAN.md` or `ISSUES.md` when the user does not specify.
- Read the selected file.
- Find the first unresolved actionable task.
- Create a concise implementation plan for that task.
- Ask concise planning questions when requirements are unclear.
- Implement only that task after planning is settled.
- Verify the change using the repo's normal test/build commands.
- Mark the completed task resolved in the source markdown file.
- Stop after one task unless the user asks to continue.

## Task Detection

Treat these as resolved:

- Checked markdown checkbox: `- [x]`
- Contains status marker: `resolved`, `done`, `fixed`, `complete`
- Struck through task text with `~~...~~`

Treat these as unresolved:

- Unchecked markdown checkbox: `- [ ]`
- Plain bullet under a task/issue section without resolved marker
- Headings or numbered items that describe pending work

Prefer explicit checkbox state over inferred status text.

## Discovery

1. Ask which file to target unless the user already named `PLAN.md` or `ISSUES.md`.
2. Read the selected file.
3. Identify the first unresolved actionable task in document order.
4. Read nearby context, linked files, and referenced code.
5. If the task is ambiguous, ask before editing.

## Planning Phase

Before editing:

1. Restate the selected task.
2. Explain the proposed fix.
3. List files likely to change.
4. List verification commands.
5. Ask unresolved questions.

Do not edit until required questions are answered or repo context makes the answer clear.

## Implementation

- Make the smallest correct change.
- Do not work on later tasks.
- Do not reorder unrelated markdown content.
- Preserve existing `PLAN.md` or `ISSUES.md` formatting.
- If another unresolved task is discovered as a prerequisite, ask before switching scope.

## Marking Resolved

After implementation and verification:

- Change `- [ ]` to `- [x]` when the task uses checkboxes.
- Otherwise append a concise status marker such as `- Resolved: <date>`.
- Preserve useful task notes.
- Do not mark resolved if verification fails, unless the failure is unrelated and clearly documented.

## Final Response

Report:

- task completed
- files changed
- verification run
- markdown task marked resolved
- unresolved follow-ups, if any

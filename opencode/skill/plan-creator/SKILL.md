---
name: plan-creator
description: Use when creating or refining PLAN.md; drives a planning-agent workflow, asks hard clarifying questions, challenges assumptions, and writes a comprehensive step-by-step implementation plan.
---

# Plan Creator

Use this skill when the user wants to create, rewrite, or refine `PLAN.md`.

## Scope

- Create or update only `PLAN.md`.
- Use planning mode or the planning agent when available.
- Research the codebase before proposing steps.
- Ask clarifying questions before writing when requirements are incomplete.
- Challenge user decisions that are vague, risky, inconsistent, or under-specified.
- Produce a concrete step-by-step implementation plan.
- Format executable work as unchecked markdown checkboxes compatible with `plan-executer`.
- Do not implement code changes from the plan.
- Do not mark work complete.

## Discovery

1. Read existing `PLAN.md` if present.
2. Explore relevant code, tests, docs, config, and commands.
3. Identify existing conventions, architectural boundaries, and verification commands.
4. Preserve useful existing plan content unless clearly stale or contradicted by the new goal.
5. Ask before replacing a large existing plan unless the user explicitly requested a rewrite.

## Planning Agent Workflow

1. Identify the user's goal.
2. Restate the goal in precise terms.
3. Identify constraints, risks, assumptions, and unknowns.
4. Ask questions until the plan is executable.
5. Challenge weak decisions with tradeoffs and consequences.
6. Draft a step-by-step plan.
7. Include tests and verification steps.
8. Include rollback or safety notes when relevant.
9. Include unresolved questions at the end.
10. Write the final plan to `PLAN.md` only after the planning phase is settled.

## User Interview

Ask about:

- desired outcome
- non-goals
- affected users or workflows
- compatibility requirements
- data migration or persisted state
- test expectations
- release or deployment constraints
- acceptable tradeoffs
- edge cases
- success criteria

Do not accept vague answers when they affect implementation. Ask concise follow-ups.

## Decision Grilling

Push back when a decision is:

- ambiguous enough to produce multiple valid implementations
- risky for compatibility, data, security, or operations
- inconsistent with repo patterns
- likely to create unnecessary abstraction or scope creep
- missing success criteria or verification

When challenging a decision, explain the tradeoff, recommend the smallest safe option, and ask for confirmation only when needed.

## PLAN.md Structure

Prefer this structure unless the repo already has a stronger convention:

```markdown
# Plan

## Goal

## Non-Goals

## Assumptions

## Decisions

## Steps

- [ ] First concrete implementation task
- [ ] Second concrete implementation task
- [ ] Add or update tests
- [ ] Run verification

## Verification

- [ ] Run relevant tests
- [ ] Run build or lint when relevant

## Risks

## Unresolved Questions
```

## Task Formatting

- Use unchecked markdown checkboxes for every executable step: `- [ ] Task`.
- Keep each checkbox independently executable by `plan-executer`.
- Write tasks in dependency order.
- Make each task small enough to complete, verify, and mark resolved in one pass.
- Include verification tasks as checkboxes when they are required before completion.
- Do not use plain bullets for executable tasks.
- Do not pre-check tasks.
- Avoid nested checkbox lists; split complex work into separate top-level tasks.

This aligns with `plan-executer`, which marks completed tasks by changing `- [ ]` to `- [x]`.

## Editing Rules

- Preserve useful existing `PLAN.md` content.
- Replace stale or contradictory content only when clearly superseded.
- Keep the plan concise but complete.
- Do not create or update `ISSUES.md`.
- Do not include agent attribution.
- Do not implement code from the plan.

## Final Response

Report:

- `PLAN.md` created or updated
- major decisions captured
- unresolved questions remaining
- whether the plan is ready for `plan-executer`

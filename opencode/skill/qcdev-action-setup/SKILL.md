---
name: qcdev-action-setup
description: Use when adding the qcdev setup-emulators composite action to a caller repo GitHub Actions workflow; asks which workflow, insertion point, and emulators to configure.
---

# QCDev Action Setup

Use this skill when the user wants to add the qcdev `setup-emulators` composite action to their own repository's GitHub Actions workflow.

## Scope

- Edit an existing caller repo workflow under `.github/workflows/`.
- Add or update one `setup-emulators` step in the requested workflow job.
- Ask where the step should run when the insertion point is not obvious.
- Ask which emulators to instantiate when not specified.
- Do not create a new workflow unless the user explicitly asks.
- Do not change test commands, fixtures, cleanup, or app config unless the user explicitly asks.

## Required Decisions

Resolve these before editing. Prefer repo context when clear; ask concise questions when missing.

1. Workflow file: which `.github/workflows/*.yml` or `.github/workflows/*.yaml` should be changed?
2. Job: which job needs Azure emulators?
3. Insertion point: which existing step should the action run before or after?
4. Emulators: one of `cosmos`, `servicebus`, `cosmos,servicebus`, or `all`.
5. Optional paths:
   - `cosmos-seed-path` when Cosmos seeding is required.
   - `servicebus-config-path` when Service Bus config loading is required.
   - `servicebus-messages-path` when Service Bus message loading is required.

Ask the user when more than one workflow, job, or plausible insertion point exists.

## Discovery

1. Inspect `.github/workflows/*.yml` and `.github/workflows/*.yaml`.
2. Identify jobs and steps that run integration, e2e, smoke, or acceptance tests.
3. Look for existing emulator, Docker, service container, `qcdev`, Cosmos, or Service Bus setup.
4. Look for seed/config/message paths in repo conventions, docs, and test commands.
5. If a `qcdev` setup step already exists, update it instead of adding a duplicate.

## Version Pinning

Pin the action `uses:` ref to the full commit SHA behind the latest `qc-dev-tools` release tag.

Use the latest release tag as the composite action `version:` input, because the action downloads release artifacts by tag.

Never use these refs for `uses:`:

- `@main`
- `@master`
- `@v1`
- `@latest`
- any branch name

Resolve latest release tag:

```bash
gh api repos/quorumcyber-clarity/qc-dev-tools/releases/latest --jq .tag_name
```

Resolve the tag to a commit SHA. Prefer peeled tags so annotated tags resolve to the target commit, not the tag object:

```bash
git ls-remote --tags https://github.com/quorumcyber-clarity/qc-dev-tools.git "refs/tags/<tag>^{}"
```

If the peeled ref returns nothing, fall back to the direct tag ref:

```bash
git ls-remote --tags https://github.com/quorumcyber-clarity/qc-dev-tools.git "refs/tags/<tag>"
```

Use the full 40-character SHA returned by the selected ref.

## Step Template

Insert this step at the chosen insertion point, adjusted only for the caller repo's requested emulator set and real paths:

```yaml
- name: Setup Azure emulators
  uses: quorumcyber-clarity/qc-dev-tools/.github/actions/setup-emulators@<release-tag-commit-sha>
  with:
    emulators: cosmos,servicebus
    version: <latest-release-tag>
    cosmos-seed-path: ./emulator/cosmosdb
    servicebus-config-path: .
    servicebus-messages-path: .
    timeout: 300
    github-token: ${{ github.token }}
```

## Inputs

- `emulators`: use the smallest emulator set needed by the caller workflow.
- `version`: latest `qc-dev-tools` release tag.
- `cosmos-seed-path`: include only when Cosmos seeding is required.
- `servicebus-config-path`: include only when Service Bus config loading is required.
- `servicebus-messages-path`: include only when Service Bus message loading is required.
- `timeout`: default to `300` unless the caller workflow needs longer startup time.
- `github-token`: pass `${{ github.token }}` when available to avoid release API rate limits.

Omit optional path inputs when the caller repo does not need that load/seed step.

## Editing Rules

- Preserve existing workflow triggers, jobs, permissions, caches, service containers, and test commands.
- Keep indentation and YAML style consistent with the caller workflow.
- Do not reorder unrelated steps.
- Do not add cleanup unless the user asks.
- Do not introduce unpinned action refs.
- If the caller repo already uses the action, update that step instead of adding another one.

## Verification

After editing, verify the workflow content by inspection.

If local tooling exists for workflow linting, run it. Do not install new tooling just for YAML validation unless the user asks.

In the final response, report:

- workflow file changed
- job changed
- insertion point used
- release tag used
- commit SHA used for `uses:`
- emulator inputs configured
- optional paths configured or omitted
- assumptions still unresolved

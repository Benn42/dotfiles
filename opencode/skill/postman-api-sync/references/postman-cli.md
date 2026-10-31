# Postman CLI Commands

Command reference checked against Postman CLI 1.44.0. Run commands from the target repository root. Start with `postman --version`; if a command or option differs, inspect that command's `--help` before proceeding. No Postman REST API calls.

## Discover (read-only)

| Purpose | Command | Notes |
| --- | --- | --- |
| Check CLI | `postman --version` | Stop and report if unavailable. |
| Check workspace subcommands | `postman workspace --help` | 1.44.0 has `prepare` and `push`, but no `list` or `lint`. |
| List workspaces, if available | `postman workspace list --json` | Only if shown in `workspace --help`. |
| List workspaces, fallback | `postman search workspaces --ownership organization --limit 25 --output json` | Read-only; use `--cursor <cursor>` to paginate. If unauthenticated, ask user to run `postman login` and stop. |
| Check for a same-named collection | `postman search collections "<collection-name>" --ownership organization --filter "workspaceId=<workspace-id>" --limit 25 --output json` | Compare exact name and workspace ID in results; paginate with `--cursor <cursor>`. If found without a local mapping, stop and ask whether to link or create a distinct collection. |

## Generate and validate local files

Write files only after the skill's explicit local-write confirmation. Preserve unmarked requests and existing mappings.

| Purpose | Command | Notes |
| --- | --- | --- |
| Migrate an existing v2.1 collection, if needed | `postman collection migrate "<source-v2.1-file>" --output "postman/collections/<collection-name>"` | Output directly to final directory; only for v2.1 input. |
| Prepare workspace | `postman workspace prepare` | Validates local resources and may regenerate IDs; inspect changes before push. |
| Lint workspace, if available | `postman workspace lint` | Only if shown in `workspace --help`. |
| Lint collection, fallback | `postman collection lint "postman/collections/<collection-name>"` | Available in 1.44.0; report substitution. `--reporter json` gives machine-readable results; default failure threshold is `error`. |

Before pushing, inspect immediate children of `postman/collections/` for unintended or empty collection directories. Check `.postman/resources.yaml` for the selected `workspace.id`; map an existing cloud collection ID when updating or renaming it.

## Sync to cloud (mutating)

After showing the exact command and getting **separate explicit cloud-sync confirmation in the current turn**, run `postman workspace push --yes` from the repository root. Default push strategy creates/updates; **never use `--push-strategy force-sync`**. Do not run `postman collection run` or `postman request` to validate generated definitions: those send requests.

---
description: Review changes with parallel @code-review subagents
agent: plan
---
Review the code changes using THREE (3) @code-review subagents and correlate results into a summary ranked by severity. Use the provided user guidance to steer the review and focus on specific code paths, changes, and/or areas of concern. Once all three @code-review subagents return their findings and you have correlated and summarized the results, consult the @oracle subagent to perform a deep review on the findings focusing on accuracy and correctness by evaluating the surrounding code, system, subsystems, abstractions, and overall architecture of each item. Apply any recommendations from the oracle. NEVER SKIP ORACLE REVIEW.

Guidance: $ARGUMENTS

First, call `skill({ name: 'vcs-detect' })` to determine whether the repo uses git or jj, then use the appropriate VCS commands throughout.

If the repo contains an ISSUES.md file, use this as the guidance for the review and pass it to the @code-review and @oracle subagents to verify ISSUES.md has been resolved.

If no ISSUES.md file exists conintue as follows:
Then review uncommitted changes by default. If no uncommitted changes, review the last commit. If the user provides a pull request/merge request number or link, use CLI tools (gh/glab) to fetch it and then perform your review.

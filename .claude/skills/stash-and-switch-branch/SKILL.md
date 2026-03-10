---
name: stash-and-switch-branch
description: Stash all changes and checkout a different branch or PR cleanly; preserves tracked and untracked work for later restoration.
---

# Stash and Switch Branch

Safely save in-progress work before switching to a PR branch or a different feature branch.

## Steps

1. **Assess the working directory**

   Check for uncommitted changes (staged, unstaged, untracked):

   ```bash
   git status
   ```

2. **Save untracked files** (if any)

   Untracked files are not included in `git stash`. Move them to a sibling directory so they can be restored later:

   ```bash
   mkdir -p ../git-stash-storage/<identifier>/
   # Move untracked files there, preserving relative paths
   ```

   Where `<identifier>` is a short description derived from the current branch name and timestamp (e.g., `feat-sqlite-20260310`).

3. **Stash tracked changes**

   ```bash
   git stash push -m "WIP: <current branch> - <brief description>"
   ```

4. **Record the stash details**

   Write to `.claude/git-stash/<identifier>.md`:

   ```
   branch: <original branch>
   stash_message: WIP: <current branch> - <brief description>
   untracked_storage: ../git-stash-storage/<identifier>/
   timestamp: <ISO timestamp>
   ```

5. **Validate the target**

   If `$ARGUMENTS` is a branch name, verify it exists:

   ```bash
   git ls-remote --heads origin <branch-name>
   ```

   If `$ARGUMENTS` is a PR URL (e.g., `https://github.com/w0rd-driven/beatseek/pull/42`), extract the branch name:

   ```bash
   gh pr view 42 --json headRefName -q '.headRefName'
   ```

   If the target is invalid, explain the problem and ask for a valid branch name or PR URL.

6. **Switch branches**

   ```bash
   git checkout <target-branch>
   # or for a PR branch:
   gh pr checkout 42
   ```

7. **Confirm clean state**

   ```bash
   git status
   ```

   Report the current branch and confirm the working directory is clean.

8. **Remind the user**

   When done switching, note: "Your previous work is stashed. Run `restore-stashed-changes` to get it back."

## Notes

- Do NOT pop the stash automatically — let the user decide when to restore
- If the stash or file move fails at any step, abort and restore the working directory to its pre-stash state before reporting the error

## Related Skills

- `restore-stashed-changes` — Restores work saved by this skill
- `use-github-cli` — `gh pr checkout` and `gh pr view` commands

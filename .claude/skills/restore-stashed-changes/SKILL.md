---
name: restore-stashed-changes
description: Restore previously stashed changes after switching back to the original branch.
---

# Restore Stashed Changes

Restore work that was saved by `stash-and-switch-branch`.

## Steps

1. **Read stash records**

   List all files in `.claude/git-stash/`:

   ```bash
   ls .claude/git-stash/
   ```

   Display each stash with its recorded branch, stash message, and timestamp.

2. **Ask the user which stash to restore**

   If there is only one stash record, confirm it is the right one before proceeding. If there are multiple, ask.

3. **Switch back to the original branch** (if not already there)

   Read the `branch:` field from the chosen stash record:

   ```bash
   git checkout <original-branch>
   ```

4. **Restore untracked files** (if any were saved)

   If the stash record has an `untracked_storage:` path, move those files back to their original locations:

   ```bash
   # Move files from ../git-stash-storage/<identifier>/ back to working directory
   ```

5. **Pop the stash**

   Match the stash by its recorded message:

   ```bash
   git stash list
   git stash pop stash@{N}  # where N matches the recorded message
   ```

6. **Verify the working directory**

   ```bash
   git status
   ```

   Confirm that all previously tracked changes are restored and untracked files are back in place.

7. **Clean up**

   Remove the stash record file:

   ```bash
   rm .claude/git-stash/<identifier>.md
   rmdir ../git-stash-storage/<identifier>/  # if empty
   ```

   Report success to the user.

## Error Handling

- If the stash pop produces conflicts, report them clearly and do not delete the stash record
- If the untracked file restore fails, leave the `.claude/git-stash/` record in place so the user can recover manually

## Related Skills

- `stash-and-switch-branch` — Creates the stash that this skill restores

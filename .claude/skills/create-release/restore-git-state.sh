#!/usr/bin/env bash
# Restore git working directory to the state before the release process.
#
# Usage: ./restore-git-state.sh <ORIGINAL_BRANCH> <STASH_CREATED> [STASH_MSG]

set -euo pipefail

ORIGINAL_BRANCH="${1:?Usage: $0 <ORIGINAL_BRANCH> <STASH_CREATED> [STASH_MSG]}"
STASH_CREATED="${2:?Usage: $0 <ORIGINAL_BRANCH> <STASH_CREATED> [STASH_MSG]}"
STASH_MSG="${3:-}"

git checkout "$ORIGINAL_BRANCH" >/dev/null 2>&1

if [ "$STASH_CREATED" = "true" ] && [ -n "$STASH_MSG" ]; then
  # Find the stash entry by message and pop it
  STASH_REF=$(git stash list | grep "$STASH_MSG" | head -1 | cut -d: -f1)
  if [ -n "$STASH_REF" ]; then
    git stash pop "$STASH_REF" >/dev/null 2>&1
    echo "RESTORED=true"
  else
    echo "WARNING: Stash entry '$STASH_MSG' not found." >&2
    echo "RESTORED=false"
  fi
else
  echo "RESTORED=skipped"
fi

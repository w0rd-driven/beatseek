#!/usr/bin/env bash
# Save current git state, validate working directory, and generate a release version.
# Outputs a KEY=VALUE block that the caller can eval or parse.
#
# Usage: ./prepare-release.sh
# Output (stdout):
#   ORIGINAL_BRANCH=<branch>
#   STASH_CREATED=true|false
#   STASH_MSG=<message>
#   VERSION=<YYYY.MM.DD.N>

set -euo pipefail

# 1. Save current branch
ORIGINAL_BRANCH=$(git branch --show-current)
if [ -z "$ORIGINAL_BRANCH" ]; then
  echo "ERROR: Detached HEAD state. Please checkout a branch first." >&2
  exit 1
fi

# 2. Stash uncommitted changes if any exist
STASH_MSG="release-prepare-$(date +%s)"
STASH_CREATED=false
if ! git diff --quiet HEAD 2>/dev/null || [ -n "$(git ls-files --others --exclude-standard)" ]; then
  git stash push -u -m "$STASH_MSG" >/dev/null 2>&1
  STASH_CREATED=true
fi

# 3. Verify clean working directory
if ! git diff --quiet HEAD 2>/dev/null; then
  echo "ERROR: Working directory not clean after stash." >&2
  exit 1
fi

# 4. Generate release version (YYYY.MM.DD.N)
#    Find the highest ordinal from existing git tags for today.
TODAY=$(date +%Y.%m.%d)
HIGHEST=$(
  git tag --list "${TODAY}.*" 2>/dev/null \
    | sed "s/^${TODAY}\.//" \
    | grep -E '^[0-9]+$' \
    | sort -n \
    | tail -1
)
ORDINAL=$(( ${HIGHEST:-0} + 1 ))
VERSION="${TODAY}.${ORDINAL}"

# Output key=value pairs
echo "ORIGINAL_BRANCH=${ORIGINAL_BRANCH}"
echo "STASH_CREATED=${STASH_CREATED}"
echo "STASH_MSG=${STASH_MSG}"
echo "VERSION=${VERSION}"

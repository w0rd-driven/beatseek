#!/usr/bin/env bash
# Create a main backup branch and an annotated release tag.
# Beatseek releases from main directly (no staging branch).
#
# Usage: ./create-release-tag.sh <VERSION>
# Output (stdout):
#   MAIN_SHA=<short-hash>
#   BACKUP_BRANCH=<name>
#   TAG_NAME=<name>

set -euo pipefail

VERSION="${1:?Usage: $0 <VERSION>}"

BACKUP_BRANCH="v${VERSION}-backup"
TAG_NAME="v${VERSION}"

# 1. Ensure we're on main with the latest changes
git checkout main >/dev/null 2>&1
git pull origin main >/dev/null 2>&1
MAIN_SHA=$(git rev-parse --short HEAD)

# 2. Create a backup branch for disaster recovery
git checkout -b "$BACKUP_BRANCH" >/dev/null 2>&1
git push -u origin "$BACKUP_BRANCH" >/dev/null 2>&1

# 3. Return to main and create the annotated release tag
git checkout main >/dev/null 2>&1
git tag -a "$TAG_NAME" -m "Release ${TAG_NAME}" >/dev/null 2>&1
git push origin "$TAG_NAME" >/dev/null 2>&1

# Output key=value pairs
echo "MAIN_SHA=${MAIN_SHA}"
echo "BACKUP_BRANCH=${BACKUP_BRANCH}"
echo "TAG_NAME=${TAG_NAME}"

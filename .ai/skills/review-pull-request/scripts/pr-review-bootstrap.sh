#!/usr/bin/env bash
set -euo pipefail

# =============================================================================
# PR Review Bootstrap Script
# Handles all mechanical setup for PR review: stash, checkout, metadata,
# diff generation, file categorization, and context summary.
#
# Artifacts are written to documentation/pr-files/ within the repo (gitignored) so that
# review subagents can read them without needing /tmp access.
# =============================================================================

PR_URL="${1:-}"

# ---------------------------------------------------------------------------
# Helpers
# ---------------------------------------------------------------------------
die() { echo "ERROR: $*" >&2; exit 1; }

# State tracking for rollback
STATE_FILE=""
ORIGINAL_BRANCH=""
DID_STASH=no
DID_MOVE_UNTRACKED=no
UNTRACKED_STORAGE=""
STASH_METADATA_DIR=""
STASH_ID=""
PR_NUMBER=""
PR_FILES_DIR=""

cleanup_on_failure() {
  local exit_code=$?
  if [[ "$exit_code" -ne 0 ]]; then
    echo "Bootstrap failed — rolling back..." >&2

    # Restore original branch
    if [[ -n "$ORIGINAL_BRANCH" ]]; then
      git checkout "$ORIGINAL_BRANCH" 2>/dev/null || true
    fi

    # Pop stash if we stashed — target by message to avoid popping the wrong stash
    if [[ "$DID_STASH" == "yes" && -n "$STASH_ID" ]]; then
      local stash_ref
      stash_ref=$(git stash list | grep "pr-review-bootstrap: ${STASH_ID}" | head -1 | cut -d: -f1)
      if [[ -n "$stash_ref" ]]; then
        git stash pop "$stash_ref" 2>/dev/null || echo "WARNING: git stash pop failed — run 'git stash list' to find your changes" >&2
      else
        echo "WARNING: could not find stash 'pr-review-bootstrap: ${STASH_ID}' — run 'git stash list' to find your changes" >&2
      fi
    fi

    # Move untracked files back
    if [[ "$DID_MOVE_UNTRACKED" == "yes" && -d "$UNTRACKED_STORAGE" ]]; then
      cp -a "$UNTRACKED_STORAGE"/. . 2>/dev/null || true
      rm -rf "$UNTRACKED_STORAGE"
    fi

    # Remove stash metadata file
    if [[ -n "$STASH_METADATA_DIR" && -n "$STASH_ID" && -f "${STASH_METADATA_DIR}/${STASH_ID}.json" ]]; then
      rm -f "${STASH_METADATA_DIR}/${STASH_ID}.json"
    fi

    # Remove any partial artifacts
    if [[ -n "$PR_FILES_DIR" ]]; then
      rm -rf "${PR_FILES_DIR}"/pr-"${PR_NUMBER}"-* 2>/dev/null || true
    fi

    [[ -n "$STATE_FILE" && -f "$STATE_FILE" ]] && rm -f "$STATE_FILE"
  fi
}
trap cleanup_on_failure EXIT

# ---------------------------------------------------------------------------
# Pre-flight checks
# ---------------------------------------------------------------------------
[[ -z "$PR_URL" ]] && die "Usage: $0 <PR_URL>"

# Accept either a full GitHub URL or a bare PR number
if echo "$PR_URL" | grep -qE '^[0-9]+$'; then
  REPO=$(gh repo view --json nameWithOwner -q '.nameWithOwner')
  PR_URL="https://github.com/${REPO}/pull/${PR_URL}"
fi

if ! echo "$PR_URL" | grep -qE '^https://github\.com/[^/]+/[^/]+/pull/[0-9]+$'; then
  die "Invalid PR URL format. Expected: https://github.com/owner/repo/pull/### or a bare PR number"
fi

# Check required tools
for cmd in gh jq git; do
  command -v "$cmd" >/dev/null 2>&1 || die "'$cmd' is required but not found"
done

# Extract PR number from URL
PR_NUMBER=$(echo "$PR_URL" | grep -oE '[0-9]+$')
[[ -z "$PR_NUMBER" ]] && die "Could not extract PR number from URL"

# ---------------------------------------------------------------------------
# Resolve artifact output directory (documentation/pr-files/ in repo root, gitignored)
# ---------------------------------------------------------------------------
REPO_ROOT=$(git rev-parse --show-toplevel)
cd "$REPO_ROOT" || die "Could not change to repo root: $REPO_ROOT"
PR_FILES_DIR="${REPO_ROOT}/documentation/pr-files"
mkdir -p "$PR_FILES_DIR"

# ---------------------------------------------------------------------------
# Fetch PR data (single API call — also validates PR exists)
# ---------------------------------------------------------------------------
PR_DATA=$(gh pr view "$PR_URL" --json number,title,author,baseRefName,headRefName,body,changedFiles,additions,deletions 2>/dev/null) \
  || die "PR $PR_URL does not exist or is not accessible"

# ---------------------------------------------------------------------------
# Clean previous run artifacts (idempotent re-runs)
# ---------------------------------------------------------------------------
rm -rf "${PR_FILES_DIR}"/pr-"${PR_NUMBER}"-*.diff \
       "${PR_FILES_DIR}"/pr-"${PR_NUMBER}"-files.txt \
       "${PR_FILES_DIR}"/pr-"${PR_NUMBER}"-files/ \
       "${PR_FILES_DIR}"/pr-"${PR_NUMBER}"-context.md \
       "${PR_FILES_DIR}"/pr-"${PR_NUMBER}"-issues.txt \
       2>/dev/null || true

PRIOR_STASH_STORAGE="${REPO_ROOT}/../git-stash-storage"
if [[ -d "$PRIOR_STASH_STORAGE" ]]; then
  for dir in "${PRIOR_STASH_STORAGE}"/pr-review-"${PR_NUMBER}"-*; do
    [[ -d "$dir" ]] && rm -rf "$dir"
  done
fi

# ---------------------------------------------------------------------------
# State file for tracking operations
# ---------------------------------------------------------------------------
STATE_FILE="${PR_FILES_DIR}/pr-bootstrap-state-${PR_NUMBER}.json"
echo '{}' > "$STATE_FILE"

# ---------------------------------------------------------------------------
# Stash & Switch Branch
# ---------------------------------------------------------------------------
ORIGINAL_BRANCH=$(git rev-parse --abbrev-ref HEAD)
STASH_ID="pr-review-${PR_NUMBER}-$(date +%s)"

HAS_TRACKED_CHANGES=no
if ! git diff --quiet || ! git diff --cached --quiet; then
  HAS_TRACKED_CHANGES=yes
fi

UNTRACKED_FILES=$(git ls-files --others --exclude-standard)
HAS_UNTRACKED=no
if [[ -n "$UNTRACKED_FILES" ]]; then
  HAS_UNTRACKED=yes
fi

if [[ "$HAS_UNTRACKED" == "yes" ]]; then
  UNTRACKED_STORAGE="${REPO_ROOT}/../git-stash-storage/${STASH_ID}"
  mkdir -p "$UNTRACKED_STORAGE"
  DID_MOVE_UNTRACKED=yes
  while IFS= read -r f; do
    target_dir="$UNTRACKED_STORAGE/$(dirname "$f")"
    mkdir -p "$target_dir"
    mv "$f" "$target_dir/" || { echo "WARNING: could not move '$f' to storage" >&2; }
  done <<< "$UNTRACKED_FILES"
fi

if [[ "$HAS_TRACKED_CHANGES" == "yes" ]]; then
  git stash push -m "pr-review-bootstrap: ${STASH_ID}" >/dev/null 2>&1
  DID_STASH=yes
fi

# Write stash metadata for restoration
# NOTE: This mirrors the stash-and-switch-branch skill format.
STASH_METADATA_DIR="${REPO_ROOT}/.claude/git-stash"
if [[ "$DID_STASH" == "yes" || "$DID_MOVE_UNTRACKED" == "yes" ]]; then
  mkdir -p "$STASH_METADATA_DIR"
  jq -n \
    --arg id "$STASH_ID" \
    --arg branch "$ORIGINAL_BRANCH" \
    --arg tracked "$DID_STASH" \
    --arg untracked "$DID_MOVE_UNTRACKED" \
    --arg storage "${UNTRACKED_STORAGE:-}" \
    --arg msg "pr-review-bootstrap: ${STASH_ID}" \
    --arg ts "$(date -u +%Y-%m-%dT%H:%M:%SZ)" \
    --arg pr "$PR_NUMBER" \
    '{id: $id, original_branch: $branch, stashed_tracked: $tracked, moved_untracked: $untracked, untracked_storage: $storage, stash_message: $msg, timestamp: $ts, pr_number: $pr}' \
    > "${STASH_METADATA_DIR}/${STASH_ID}.json"
fi

jq -n \
  --arg stashed "$DID_STASH" \
  --arg moved "$DID_MOVE_UNTRACKED" \
  --arg branch "$ORIGINAL_BRANCH" \
  --arg id "$STASH_ID" \
  '{stashed: $stashed, moved_untracked: $moved, original_branch: $branch, stash_id: $id}' \
  > "$STATE_FILE"

HEAD_BRANCH=$(echo "$PR_DATA" | jq -r '.headRefName')

git fetch origin "$HEAD_BRANCH" >/dev/null 2>&1 || die "Could not fetch branch '$HEAD_BRANCH'"
git checkout "$HEAD_BRANCH" >/dev/null 2>&1 || die "Could not checkout branch '$HEAD_BRANCH'"

# ---------------------------------------------------------------------------
# PR Metadata Extraction
# ---------------------------------------------------------------------------
PR_TITLE=$(echo "$PR_DATA" | jq -r '.title')
PR_AUTHOR=$(echo "$PR_DATA" | jq -r '.author.login')
BASE_BRANCH=$(echo "$PR_DATA" | jq -r '.baseRefName')
ADDITIONS=$(echo "$PR_DATA" | jq -r '.additions')
DELETIONS=$(echo "$PR_DATA" | jq -r '.deletions')
FILES_CHANGED=$(echo "$PR_DATA" | jq -r '.changedFiles')

# ---------------------------------------------------------------------------
# GitHub Issue Extraction
# Look for "Closes #NNN", "Fixes #NNN", "Resolves #NNN" in the PR body
# ---------------------------------------------------------------------------
PR_BODY=$(echo "$PR_DATA" | jq -r '.body // ""')
ISSUE_NUMBER=$(echo "$PR_BODY" | grep -oiE '(closes|fixes|resolves)\s+#[0-9]+' | grep -oE '[0-9]+' | head -1 || true)
ISSUE_TITLE="none"
ISSUE_LABELS="none"

if [[ -n "$ISSUE_NUMBER" ]]; then
  ISSUE_DATA=$(gh issue view "$ISSUE_NUMBER" --json title,labels 2>/dev/null || true)
  if [[ -n "$ISSUE_DATA" ]]; then
    ISSUE_TITLE=$(echo "$ISSUE_DATA" | jq -r '.title // "unknown"')
    ISSUE_LABELS=$(echo "$ISSUE_DATA" | jq -r '[.labels[].name] | join(", ")' 2>/dev/null || echo "none")
    echo "Issue #${ISSUE_NUMBER}: ${ISSUE_TITLE}" > "${PR_FILES_DIR}/pr-${PR_NUMBER}-issues.txt"
    echo "Labels: ${ISSUE_LABELS}" >> "${PR_FILES_DIR}/pr-${PR_NUMBER}-issues.txt"
  fi
fi
[[ -z "$ISSUE_NUMBER" ]] && ISSUE_NUMBER="none"

# ---------------------------------------------------------------------------
# Diff & File Context Generation
# ---------------------------------------------------------------------------
gh pr diff "$PR_NUMBER" > "${PR_FILES_DIR}/pr-${PR_NUMBER}-full.diff" 2>/dev/null || die "Could not generate diff"
gh pr diff "$PR_NUMBER" --name-only > "${PR_FILES_DIR}/pr-${PR_NUMBER}-files.txt" 2>/dev/null || die "Could not list changed files"

CHANGED_FILES=$(cat "${PR_FILES_DIR}/pr-${PR_NUMBER}-files.txt")

# ---------------------------------------------------------------------------
# File category detection — Elixir/Phoenix/Beatseek patterns
# ---------------------------------------------------------------------------
HAS_FRONTEND=no
HAS_BACKEND=no
HAS_MIGRATIONS=no
HAS_INFRA=no
HAS_CONFIG=no
HAS_TESTS=no
HAS_WORKERS=no
HAS_AUTH=no

# Frontend: LiveView modules, HEEx templates, components, assets
echo "$CHANGED_FILES" | grep -qE '\.html\.heex$|lib/beatseek_web/live/|lib/beatseek_web/components/|assets/' \
  && HAS_FRONTEND=yes || true

# Backend: Elixir context and domain modules
echo "$CHANGED_FILES" | grep -qE '^lib/beatseek/' \
  && HAS_BACKEND=yes || true

# Migrations: Ecto migration files (Postgres and SQLite paths)
echo "$CHANGED_FILES" | grep -qE 'priv/repo/migrations' \
  && HAS_MIGRATIONS=yes || true

# Infrastructure: Fly.io config, Dockerfile, GitHub Actions
echo "$CHANGED_FILES" | grep -qE 'fly\.toml|Dockerfile|\.github/' \
  && HAS_INFRA=yes || true

# Configuration: Elixir config files, env example
echo "$CHANGED_FILES" | grep -qE '^config/|\.env\.example' \
  && HAS_CONFIG=yes || true

# Tests: ExUnit test files
echo "$CHANGED_FILES" | grep -qE '^test/' \
  && HAS_TESTS=yes || true

# Oban workers
echo "$CHANGED_FILES" | grep -qE 'lib/beatseek/workers/' \
  && HAS_WORKERS=yes || true

# Auth: user auth, accounts, session modules
echo "$CHANGED_FILES" | grep -qE 'user_auth|accounts|user_session|user_registration|user_login|user_confirmation' \
  && HAS_AUTH=yes || true

# Copy changed file contents for agent access
mkdir -p "${PR_FILES_DIR}/pr-${PR_NUMBER}-files"
while IFS= read -r filepath; do
  if [[ -f "$filepath" ]]; then
    mkdir -p "${PR_FILES_DIR}/pr-${PR_NUMBER}-files/$(dirname "$filepath")"
    cp "$filepath" "${PR_FILES_DIR}/pr-${PR_NUMBER}-files/$filepath"
  fi
done < "${PR_FILES_DIR}/pr-${PR_NUMBER}-files.txt"

# ---------------------------------------------------------------------------
# Context Summary File
# ---------------------------------------------------------------------------
ISSUE_CONTENT="No linked issue"
if [[ -f "${PR_FILES_DIR}/pr-${PR_NUMBER}-issues.txt" ]]; then
  ISSUE_CONTENT=$(cat "${PR_FILES_DIR}/pr-${PR_NUMBER}-issues.txt")
fi

cat > "${PR_FILES_DIR}/pr-${PR_NUMBER}-context.md" <<CONTEXT_EOF
# PR Context Summary

## Pull Request
- **Number**: #${PR_NUMBER}
- **Title**: ${PR_TITLE}
- **Author**: ${PR_AUTHOR}
- **Branch**: ${HEAD_BRANCH} -> ${BASE_BRANCH}
- **Changes**: +${ADDITIONS} -${DELETIONS} across ${FILES_CHANGED} files

## Linked Issue
${ISSUE_CONTENT}

## Files Changed
${CHANGED_FILES}

## Change Categories Detected
- Frontend (LiveView/HEEx/assets): $([[ "$HAS_FRONTEND" == "yes" ]] && echo "Yes" || echo "No")
- Backend (Elixir contexts): $([[ "$HAS_BACKEND" == "yes" ]] && echo "Yes" || echo "No")
- Database/Migrations: $([[ "$HAS_MIGRATIONS" == "yes" ]] && echo "Yes" || echo "No")
- Infrastructure (fly.toml/Dockerfile/CI): $([[ "$HAS_INFRA" == "yes" ]] && echo "Yes" || echo "No")
- Configuration: $([[ "$HAS_CONFIG" == "yes" ]] && echo "Yes" || echo "No")
- Tests: $([[ "$HAS_TESTS" == "yes" ]] && echo "Yes" || echo "No")
- Oban Workers: $([[ "$HAS_WORKERS" == "yes" ]] && echo "Yes" || echo "No")
- Auth/Accounts: $([[ "$HAS_AUTH" == "yes" ]] && echo "Yes" || echo "No")
CONTEXT_EOF

# ---------------------------------------------------------------------------
# Structured Output
# ---------------------------------------------------------------------------
trap - EXIT

sanitize() { printf '%s' "$1" | tr -d '\n\r' | tr -s ' '; }

cat <<OUTPUT_EOF
===PR_REVIEW_BOOTSTRAP_START===
PR_NUMBER=${PR_NUMBER}
PR_TITLE=$(sanitize "$PR_TITLE")
PR_AUTHOR=$(sanitize "$PR_AUTHOR")
HEAD_BRANCH=$(sanitize "$HEAD_BRANCH")
BASE_BRANCH=$(sanitize "$BASE_BRANCH")
ADDITIONS=${ADDITIONS}
DELETIONS=${DELETIONS}
FILES_CHANGED=${FILES_CHANGED}
ISSUE_NUMBER=${ISSUE_NUMBER}
ISSUE_TITLE=$(sanitize "$ISSUE_TITLE")
ISSUE_LABELS=$(sanitize "$ISSUE_LABELS")
ORIGINAL_BRANCH=${ORIGINAL_BRANCH}
STASH_ID=${STASH_ID}
DID_STASH=${DID_STASH}
DID_MOVE_UNTRACKED=${DID_MOVE_UNTRACKED}
HAS_FRONTEND=${HAS_FRONTEND}
HAS_BACKEND=${HAS_BACKEND}
HAS_MIGRATIONS=${HAS_MIGRATIONS}
HAS_INFRA=${HAS_INFRA}
HAS_CONFIG=${HAS_CONFIG}
HAS_TESTS=${HAS_TESTS}
HAS_WORKERS=${HAS_WORKERS}
HAS_AUTH=${HAS_AUTH}
CONTEXT_FILE=${PR_FILES_DIR}/pr-${PR_NUMBER}-context.md
DIFF_FILE=${PR_FILES_DIR}/pr-${PR_NUMBER}-full.diff
FILES_LIST=${PR_FILES_DIR}/pr-${PR_NUMBER}-files.txt
FILES_DIR=${PR_FILES_DIR}/pr-${PR_NUMBER}-files/
ISSUES_FILE=${PR_FILES_DIR}/pr-${PR_NUMBER}-issues.txt
STASH_METADATA=$( [[ "$DID_STASH" == "yes" || "$DID_MOVE_UNTRACKED" == "yes" ]] && echo "${STASH_METADATA_DIR}/${STASH_ID}.json" || echo "" )
===PR_REVIEW_BOOTSTRAP_END===
OUTPUT_EOF

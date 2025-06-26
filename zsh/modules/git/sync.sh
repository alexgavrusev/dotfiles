#! /bin/bash

set -euo pipefail

BASE_BRANCH="main"
ORIGINAL_BRANCH=$(git rev-parse --abbrev-ref HEAD)

if [ "$#" -eq 1 ]; then
    BASE_BRANCH="$1"
elif [ "$#" -gt 1 ]; then
    echo "Error: Invalid number of arguments." >&2
    echo "Usage:" >&2
    echo "  $0                 (Syncs current branch with local 'main' after updating 'main')" >&2
    echo "  $0 <base_branch>   (Syncs current branch with local <base_branch> after updating <base_branch>)" >&2
    exit 1
fi

current_for_base_update=$(git rev-parse --abbrev-ref HEAD)
if [ "$current_for_base_update" != "$BASE_BRANCH" ]; then
    git checkout "$BASE_BRANCH"
fi

git pull origin "$BASE_BRANCH"

if [ "$BASE_BRANCH" != "$ORIGINAL_BRANCH" ]; then
    git checkout "$ORIGINAL_BRANCH"
fi

git pull origin "$ORIGINAL_BRANCH"

if [ "$ORIGINAL_BRANCH" != "$BASE_BRANCH" ]; then
    # Ensure clean state before merge - this fixes the "fatal: stash failed" error
    git update-index --refresh
    git reset --quiet HEAD
    git clean -fd

    git merge "$BASE_BRANCH"
fi

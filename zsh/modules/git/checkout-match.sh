#! /bin/bash

set -uo pipefail

if [ $# -eq 0 ]; then
    echo "Usage: $0 <search-term>"
    exit 1
fi

search_term=$1

# First, check local branches
local_matches=$(git for-each-ref --format='%(refname:short)' refs/heads | grep -i "$search_term" || true)
local_count=$(echo "$local_matches" | grep -v '^$' | wc -l)

if [ "$local_count" -gt 1 ]; then
    echo "Multiple local branches found:"
    echo "$local_matches"
    exit 1
elif [ "$local_count" -eq 1 ]; then
    # Single local match found - direct checkout
    echo "Found local branch: $local_matches"
    git checkout "$local_matches"
else
    # If no local matches, check remote branches
    remote_matches=$(git for-each-ref --format='%(refname:short)' refs/remotes/origin | grep -i "$search_term" || true)
    remote_count=$(echo "$remote_matches" | grep -v '^$' | wc -l)

    if [ "$remote_count" -eq 0 ]; then
        echo "No branches found matching: $search_term"
        exit 1
    elif [ "$remote_count" -gt 1 ]; then
        echo "Multiple remote branches found:"
        echo "$remote_matches"
        exit 1
    else
        # Single remote match found - create tracking branch
        remote_branch=$remote_matches
        local_branch=${remote_branch#origin/}

        if git show-ref --verify --quiet "refs/heads/$local_branch"; then
            echo "Local branch '$local_branch' already exists"
            git checkout "$local_branch"
        else
            echo "Creating tracking branch for $remote_branch"
            git checkout -b "$local_branch" "$remote_branch"
        fi
    fi
fi

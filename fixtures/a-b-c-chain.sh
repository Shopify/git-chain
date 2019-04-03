#!/bin/bash

set -e

git init >/dev/null

for b in master a b c; do
    git checkout -b $b 2>/dev/null
    git commit --allow-empty -m "$b.1" >/dev/null
done

for b in master a b c; do
    git checkout $b 2>/dev/null
    git commit --allow-empty -m "$b.2" >/dev/null
done

PREV=""
for b in master a b c; do
    git config branch.$b.chain default
    if [[ ! -z "$PREV" ]]; then
        git config branch.$b.parentBranch $PREV
        git config branch.$b.branchPoint $(git rev-parse $PREV^)
    fi
    PREV=$b
done

#!/bin/bash

set -e

git init

for b in master a b; do
    git checkout -b $b
    git commit --allow-empty -m "$b.1"
done

for b in master a b; do
    git checkout $b
    git commit --allow-empty -m "$b.2"
done

PREV=""
for b in master a b; do
    if [[ ! -z "$PREV" ]]; then
        git config branch.$b.chain default
        git config branch.$b.parentBranch $PREV
        git config branch.$b.branchPoint $(git rev-parse $PREV^)
    fi
    PREV=$b
done

git checkout master
git merge a -m 'merge a -> master'
git checkout b

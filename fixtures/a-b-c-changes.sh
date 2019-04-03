#!/bin/bash

set -e

git init >/dev/null

for b in master a b c; do
    git checkout -b $b 2>/dev/null
    echo Hello from $b > $b.txt
    git add $b.txt
    git commit -m "$b.1" >/dev/null
done

git checkout a 2>/dev/null
echo Conflicting change > b.txt
git add b.txt
git commit -m "a.2 (conflicting)" > /dev/null

git checkout master >/dev/null


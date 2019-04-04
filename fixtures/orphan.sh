#!/bin/bash

set -e

git init

for b in a b; do
    git checkout --orphan $b
    git commit --allow-empty -m "$b.1"
    git commit --allow-empty -m "$b.2"
done

git checkout b -b c
git commit --allow-empty -m "c.1"

# * 9d236b9  (a)
# |   a.2
# * e4bc0a0
#     a.1
# * 4a2e01b  (HEAD -> c)
# |   c.1
# * ec3703c  (b)
# |   b.2
# * 3fe3ff4
#     b.1

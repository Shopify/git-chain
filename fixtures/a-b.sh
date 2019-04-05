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

git checkout master

# * 8460cfb  (b)
# |   b.2
# * a1f095b
# |   b.1
# | * 51a588d
# |/    a.2
# * 2efca32
# |   a.1
# | * 84aca1c  (HEAD -> master)
# |/    master.2
# * cea123e
#     master.1

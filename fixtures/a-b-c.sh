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

git checkout master 2>/dev/null

# * 8460cfb  (c)
# |   c.2
# * a1f095b
# |   c.1
# | * 8acf6e7  (a)
# | |   a.2
# | | * 2500cda  (b)
# | |/    b.2
# |/|
# * | 51a588d
# |/    b.1
# * 2efca32
# |   a.1
# | * 84aca1c  (HEAD -> master)
# |/    master.2
# * cea123e
#     master.1

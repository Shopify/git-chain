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

* 7748320 (a) a.2 (conflicting)
| * d522f2f (c) c.1
| * 74a490d (b) b.1
|/
* d89f9f4 a.1
* cc71e35 (HEAD -> master) master.1
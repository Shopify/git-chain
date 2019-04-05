#!/bin/bash

set -e

git init

for b in master feature-database feature-model feature-ui; do
    git checkout -b $b
    git commit --allow-empty -m "$b.1"
done

for b in master feature-database feature-model feature-ui; do
    git checkout $b
    git commit --allow-empty -m "$b.2"
done
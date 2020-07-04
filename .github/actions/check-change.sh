#!/bin/bash
set -eu

AUTO_MERGE_DIR_REGEX='check-change/.*/auto-merge/.*.yaml'
git fetch origin master
NON_AUTOMERGE_FILE_NUM=$(git diff --name-only origin/master HEAD | grep -vE $AUTO_MERGE_DIR_REGEX)
if [[ $NON_AUTOMERGE_FILE_NUM = 0 ]];then
    echo "Can auto merge" >> comments
else
    echo "Cannot auto merge as the following files are changed:" >> comments
    git diff --name-only origin/master HEAD | grep -vE $AUTO_MERGE_DIR_REGEX >> comments
    sed -i -z 's/\n/\\n/g' comments
fi
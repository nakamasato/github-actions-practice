#!/bin/bash
set -eu

AUTO_MERGE_DIR_REGEX='check-change/.*/auto-merge/.*.yaml'
git fetch origin "$BASE_BRANCH"
NON_AUTOMERGE_FILE_NUM=$(git diff --name-only "origin/$BASE_BRANCH" HEAD | grep -vE "$AUTO_MERGE_DIR_REGEX")
PR_COMMENT_CONTENT_TMP_FILE=comment
if [ "$NON_AUTOMERGE_FILE_NUM" == 0 ];then
    echo "auto-approve" >> $PR_COMMENT_CONTENT_TMP_FILE
else
    echo "auto-approve is skipped as the following files are changed:" >> $PR_COMMENT_CONTENT_TMP_FILE
    { echo "\`\`\`"; git diff --name-only origin/master HEAD | grep -vE "$AUTO_MERGE_DIR_REGEX"; echo "\`\`\`"; } >> $PR_COMMENT_CONTENT_TMP_FILE
fi
echo "GITHUB_REF: $GITHUB_REF"
echo "GITHUB_SHA: $GITHUB_SHA"
echo "SOURCE_BRANCH $SOURCE_BRANCH"
echo "BASE_BRANCH $BASE_BRANCH"
echo "GITHUB_REPOSITORY: $GITHUB_REPOSITORY"

echo "auto-approve condition is: \`$AUTO_MERGE_DIR_REGEX\` defined in $GITHUB_REPOSITORY/.github/actions/check-change.sh" >> $PR_COMMENT_CONTENT_TMP_FILE
sed -i -z 's/\n/\\n/g' $PR_COMMENT_CONTENT_TMP_FILE

export NON_AUTOMERGE_FILE_NUM=$NON_AUTOMERGE_FILE_NUM
echo "Done"
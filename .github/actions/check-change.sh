#!/bin/bash
set -eu

AUTO_MERGE_FILE_PATH_REGEX='check-change/.*/auto-merge/.*.yaml'
AUTO_MERGE_ALLOWED_REGEX='(image)'
PR_COMMENT_CONTENT_TMP_FILE=comment
if [ -f $PR_COMMENT_CONTENT_TMP_FILE ]; then rm $PR_COMMENT_CONTENT_TMP_FILE; fi
BASE_BRANCH=${BASE_BRANCH:-master}
SOURCE_BRANCH=${SOURCE_BRANCH:-$(git rev-parse --abbrev-ref HEAD)}

git fetch origin "$BASE_BRANCH"
AUTO_MERGE_NOT_MATCH_FILE_NUM=$(git diff --name-only "origin/$BASE_BRANCH" HEAD | grep -vE "$AUTO_MERGE_FILE_PATH_REGEX" | wc -l)

file_check=' '
change_check=' '
if [ "$AUTO_MERGE_NOT_MATCH_FILE_NUM" == 0 ];then
    file_check='x'
    AUTO_MERGE_NOT_MATCH_LINE_NUM=$(git diff origin/master HEAD | grep -vE "$AUTO_MERGE_ALLOWED_REGEX" | wc -l)
    if [ "$AUTO_MERGE_NOT_MATCH_LINE_NUM" == 0 ];then
        change_check='x'
        # echo "**message:** auto-approved" >> $PR_COMMENT_CONTENT_TMP_FILE
    else
        # echo "**message:** auto-approve is skipped as following lines are changed:" >> $PR_COMMENT_CONTENT_TMP_FILE
        # { echo "\`\`\`"; git diff origin/master HEAD | grep -vE "$AUTO_MERGE_ALLOWED_REGEX"; echo "\`\`\`"; } >> $PR_COMMENT_CONTENT_TMP_FILE
        change_check_detail="**message:** auto-approve is skipped as following lines are changed:
        \`\`\`
        $(git diff origin/master HEAD | grep -vE $AUTO_MERGE_ALLOWED_REGEX)
        \`\`\`
        "
    fi
else
    # echo "**message:** auto-approve is skipped as the following files are changed:" >> $PR_COMMENT_CONTENT_TMP_FILE
    # { echo "\`\`\`"; git diff --name-only origin/master HEAD | grep -vE "$AUTO_MERGE_FILE_PATH_REGEX"; echo "\`\`\`"; } >> $PR_COMMENT_CONTENT_TMP_FILE
    file_check_detail="**message:** auto-approve is skipped as the following files are changed:
    \`\`\`
    $(git diff --name-only origin/master HEAD | grep -vE $AUTO_MERGE_FILE_PATH_REGEX)
    \`\`\`
    "
fi

echo "
auto-approve condition (defined in \`.github/actions/check-change.sh\`) is:
- [$file_check] files: \`$AUTO_MERGE_FILE_PATH_REGEX\`
    ${file_check_detail:-}
- [$change_check] changes: \`$AUTO_MERGE_ALLOWED_REGEX\`
    ${change_check_detail:-}
" >> $PR_COMMENT_CONTENT_TMP_FILE
sed -i -z 's/\n/\\n/g' $PR_COMMENT_CONTENT_TMP_FILE

export AUTO_MERGE_NOT_MATCH_FILE_NUM=$AUTO_MERGE_NOT_MATCH_FILE_NUM
echo "Done"

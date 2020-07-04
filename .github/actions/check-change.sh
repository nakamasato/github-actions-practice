#!/bin/bash
set -eu

AUTO_MERGE_FILE_PATH_REGEX='check-change/.*/auto-merge/.*.yaml'
AUTO_MERGE_ALLOWED_REGEX='(image)'
PR_COMMENT_CONTENT_TMP_FILE=comment
if [ -f $PR_COMMENT_CONTENT_TMP_FILE ]; then rm $PR_COMMENT_CONTENT_TMP_FILE; fi
BASE_BRANCH=${BASE_BRANCH:-master}
SOURCE_BRANCH=${SOURCE_BRANCH:-$(git rev-parse --abbrev-ref HEAD)}

git fetch origin "$BASE_BRANCH"
AUTO_MERGE_NOT_MATCH_FILE_NUM=$(git diff --name-only "origin/$BASE_BRANCH" HEAD | grep -vE "$AUTO_MERGE_FILE_PATH_REGEX" | wc -l | sed 's/ //g')

file_check=' '
change_check=' '
if [ "$AUTO_MERGE_NOT_MATCH_FILE_NUM" == 0 ];then
    file_check='x'
    AUTO_MERGE_NOT_MATCH_LINE_NUM=$(git diff origin/master HEAD | grep -vE "$AUTO_MERGE_ALLOWED_REGEX" | wc -l | sed 's/ //g')
    if [ "$AUTO_MERGE_NOT_MATCH_LINE_NUM" == 0 ];then
        change_check='x'
        message="all passed"
        AUTO_APPROVE=1
    else
        message="skipped as following lines are changed
        \`\`\`
        $(git diff origin/master HEAD | grep -vE $AUTO_MERGE_ALLOWED_REGEX)
        \`\`\`
        "
    fi
else
    message="skipped as the following files are changed
\`\`\`
$(git diff --name-only origin/master HEAD | grep -vE $AUTO_MERGE_FILE_PATH_REGEX)
\`\`\`
"
fi

echo "
## auto-approve condition 
(defined in \`.github/actions/check-change.sh\`):
1. [$file_check] files: \`$AUTO_MERGE_FILE_PATH_REGEX\`
1. [$change_check] changes: \`$AUTO_MERGE_ALLOWED_REGEX\`
## message
${message:-}
" >> $PR_COMMENT_CONTENT_TMP_FILE
sed -i -z 's/\n/\\n/g' $PR_COMMENT_CONTENT_TMP_FILE

export AUTO_MERGE_NOT_MATCH_FILE_NUM=$AUTO_MERGE_NOT_MATCH_FILE_NUM
echo "::set-env name=AUTO_APPROVE::${AUTO_APPROVE:-0}"

echo "Done"

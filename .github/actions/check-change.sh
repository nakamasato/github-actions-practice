#!/bin/bash
set -eu

if [[ -z "${AUTO_APPROVE_FILE_PATH_REGEX:-}" ]]; then
    echo "Please set AUTO_APPROVE_FILE_PATH_REGEX. e.g. \`export AUTO_APPROVE_FILE_PATH_REGEX='check-change/.*/auto-merge/.*.yaml'\`"
    exit 1
fi
if [[ -z "${AUTO_APPROVE_ALLOWED_REGEX:-}" ]]; then
    echo "Please set AUTO_APPROVE_ALLOWED_REGEX. e.g. \`export AUTO_APPROVE_ALLOWED_REGEX='(image|replicas)'\`"
    exit 1
fi

PR_COMMENT_CONTENT_TMP_FILE=${PR_COMMENT_CONTENT_TMP_FILE:-comment}
if [ -f "$PR_COMMENT_CONTENT_TMP_FILE" ]; then rm "$PR_COMMENT_CONTENT_TMP_FILE"; fi
BASE_BRANCH=${BASE_BRANCH:-main}
SOURCE_BRANCH=${SOURCE_BRANCH:-$(git rev-parse --abbrev-ref HEAD)}
echo "BASE_BRANCH: $BASE_BRANCH, SOURCE_BRANCH: $SOURCE_BRANCH"

git fetch origin "$BASE_BRANCH"
AUTO_APPROVE_NOT_MATCH_FILE_NUM=$(git diff --name-only "origin/$BASE_BRANCH" HEAD | grep -cvE "$AUTO_APPROVE_FILE_PATH_REGEX" | sed 's/ //g')

file_check=' '
change_check=' '
if [ "$AUTO_APPROVE_NOT_MATCH_FILE_NUM" == 0 ];then
    POST_COMMENT=1
    file_check='x'
    AUTO_APPROVE_NOT_MATCH_LINE_NUM=$(git diff --ignore-space-at-eol --unified=0 "origin/$BASE_BRANCH" HEAD | grep '^[+-] ' | grep -cvE "$AUTO_APPROVE_ALLOWED_REGEX" | sed 's/ //g')
    if [ "$AUTO_APPROVE_NOT_MATCH_LINE_NUM" == 0 ];then
        change_check='x'
        message="all passed"
        AUTO_APPROVE=1
    else
        message="skipped as following lines are changed
\`\`\`
$(git diff --ignore-space-at-eol --unified=0 "origin/$BASE_BRANCH" HEAD | grep '^[+-] ' | grep -vE "$AUTO_APPROVE_ALLOWED_REGEX")
\`\`\`
"
    fi
else
    message="skipped as the following files are changed
\`\`\`
$(git diff --name-only "origin/$BASE_BRANCH" HEAD | grep -vE "$AUTO_APPROVE_FILE_PATH_REGEX")
\`\`\`
"
fi

echo "
## auto-approve condition
(defined in \`.github/actions/check-change.sh\`)
1. [$file_check] files: \`$AUTO_APPROVE_FILE_PATH_REGEX\`
1. [$change_check] changes: \`$AUTO_APPROVE_ALLOWED_REGEX\`
## message
${message:-}
" >> "$PR_COMMENT_CONTENT_TMP_FILE"
sed -i -z 's/\n/\\n/g' "$PR_COMMENT_CONTENT_TMP_FILE"

echo "AUTO_APPROVE=${AUTO_APPROVE:-0}" >> "$GITHUB_OUTPUT"
echo "POST_COMMENT=${POST_COMMENT:-0}" >> "$GITHUB_OUTPUT"

echo "Done (AUTO_APPROVE_NOT_MATCH_FILE_NUM: $AUTO_APPROVE_NOT_MATCH_FILE_NUM, AUTO_APPROVE_NOT_MATCH_LINE_NUM: ${AUTO_APPROVE_NOT_MATCH_LINE_NUM:-UNDEFINED})"

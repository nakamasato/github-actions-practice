echo "GITHUB_SHA: $GITHUB_SHA"
echo "GITHUB_REF: $GITHUB_REF"
AUTO_MERGE_DIR_REGEX='check-change/.*/auto-merge/.*.yaml'
git fetch origin master
NON_AUTOMERGE_FILES=$(git diff --name-only origin/master HEAD | grep -vE $AUTO_MERGE_DIR_REGEX)
echo $NON_AUTOMERGE_FILES
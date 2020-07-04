echo "GITHUB_SHA: $GITHUB_SHA"
echo "GITHUB_REF: $GITHUB_REF"
TARGET_BRANCH=master
git diff --name-only master HEAD
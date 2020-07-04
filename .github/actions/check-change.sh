echo "GITHUB_SHA: $GITHUB_SHA"
echo "GITHUB_REF: $GITHUB_REF"
git fetch origin master
git diff --name-only origin/master HEAD
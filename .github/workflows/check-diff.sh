name: check-diff

on:
  pull_request:
    paths:
      - .github/workflows/check-diff.yml
env:
  FILENAME: aaa.txt

jobs:
  no-diff:
    runs-on: ubuntu-latest
    steps:
      - name: check diff
        env:
          BASE_BRANCH: ${{ github.base_ref }}
        run: |
          git fetch origin ${BASE_BRANCH}:${BASE_BRANCH}
          git diff ${BASE_BRANCH}:${FILENAME} ${FILENAME}

  diff:
    runs-on: ubuntu-latest
    steps:
      - name: check diff
        env:
          BASE_BRANCH: ${{ github.base_ref }}
        run: |
          echo "aa" >> ${FILENAME}
          git fetch origin ${BASE_BRANCH}:${BASE_BRANCH}
          git diff ${BASE_BRANCH}:${FILENAME} ${FILENAME}

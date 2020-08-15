# github-actions-practice

## Reference

### Event

1. event: `pull_request`
    - Get PR number: `PR_NUMBER=${{ github.event.number }}`
    - Get sha: `${{ github.sha }}`
    - Get repository: `${{ github.repository }}`
    - Get label name for `labeled` type: `${{ github.event.label.name }}`
    - Get source branch: `${{ github.head_ref }}`
    - Get base branch: `${{ github.base_ref }}`
    - Whether the PR is `draft`
        ```
        if: github.event.pull_request.draft == false
        ```
    - Whether the label is in the whitelist
        ```
        if: ${{ github.event.action == 'labeled' && contains(toJson('["test", "build"]'), github.event.label.name) }}
        ```
1. event: `push`


### Triggers
- pull request
    > Note: By default, a workflow only runs when a pull_request's activity type is `opened`, `synchronize`, or `reopened`. (https://docs.github.com/en/actions/reference/events-that-trigger-workflows#pull-request-event-pull_request)
    
    - specify types:
    ```
    on:
      pull_request:
        types: [assigned, opened, synchronize, reopened, ready_for_review]
    ```
- release
### Outputs
- https://docs.github.com/en/actions/reference/workflow-syntax-for-github-actions#jobsjob_idruns-on

    set outputs:

    ```
    echo "::set-output name=<your var name>::<value>"
    ```
    use:
    
    ```
    ${{ steps.<step_id>.outputs.<your var name> }}
    ```

### Context
- https://docs.github.com/en/actions/reference/context-and-expression-syntax-for-github-actions#contexts
example:
- skip draft PR
    ```
    if: github.event.pull_request.draft == false
    ```
    
### Senarios

- Whether commit message contains `[skip ci]`:
    ```
    if: contains(github.event.head_commit.message, '[skip ci]') == false
    ```
    
- Skip next job

```
  skipci:
    runs-on: ubuntu-18.04
    outputs:
      is_skip: ${{ steps.is_skip.outputs.is_skip }}
    steps:
      - name: Set is_skip
        id: is_skip
        run: echo "::set-output name=is_skip::${{ contains(github.event.head_commit.message, '[skip ci]') }}"
      - run: echo "[skip ci] ${{ steps.is_skip.outputs.is_skip }}"

  test:
    runs-on: ubuntu-18.04
    needs: skipci
    if: ${{ ! needs.skipci.outputs.is_skip }}
    steps:
```

### Env
- [default environment variables](https://docs.github.com/en/actions/configuring-and-managing-workflows/using-environment-variables#default-environment-variables)

Example:
- source branch and base brach of PR
    
    ```
    env:
      SOURCE_BRANCH: ${{ github.head_ref }}
      BASE_BRANCH: ${{ github.base_ref }}
    ```

## Example: Conditional auto approve

Configuration:
- `AUTO_APPROVE_FILE_PATH_REGEX`: All the changed files in a PR need to match the regular expression. e.g. `check-change/.*/auto-merge/.*.yaml` <-
- `AUTO_APPROVE_ALLOWED_REGEX`: All the changed lines need to match the regular expression. e.g. `'(image)'`

Github Actions:
- `.github/workflows/conditional-auto-approve.yml`

## Example: Test mvn with MySQL

```
  test:
    runs-on: ubuntu-latest

    services:
      mysql:
        image: mysql:5.7
        options: --health-cmd "mysqladmin ping -h localhost" --health-interval 20s --health-timeout 10s --health-retries 10
        ports:
          - 3306
        env:
          MYSQL_ROOT_PASSWORD: root_password
          MYSQL_DATABASE: test_db

    steps:
      - uses: actions/checkout@v1
      - uses: actions/cache@v1
        with:
          path: ~/.m2/repository
          key: ${{ runner.os }}-maven-${{ hashFiles('**/pom.xml') }}
          restore-keys: |
            ${{ runner.os }}-maven-
      - name: Set up JDK 1.8
        uses: actions/setup-java@v1
        with:
          java-version: 1.8
      - name: Test with Maven
        env:
          MYSQL_PORT: ${{ job.services.mysql.ports[3306] }}
          MYSQL_HOST: 127.0.0.1
          MYSQL_USERNAME: root
          MYSQL_PASSWORD: root_password
          MYSQL_DB: test_db
        run: mvn test
```

# Directory

```
± tree .github/workflows/
.github/workflows/
├── auto-approve.yml
├── auto-merge.yml
├── awscli.yml
├── branch-and-tag.yml
├── check-change.yml
├── jq.yml
├── pip-cache.yml
├── pip-no-cache.yml
├── prereleased.yml
├── pull-request.yml
├── released.yml
└── zip.yml

0 directories, 12 files
```

# github-actions-practice

- Last Updated: 2024-11-01
- Last Merged PR: #1699

## Github Actions Table

### 1. pull_request

- `github.sha` is not the latest commit sha [ref](https://sue445.hatenablog.com/entry/2021/01/07/004835) <- you can use this sha for the `closed` type to get the latest commit on the `main` branch.
- `github.event.pull_request.head.sha` is the sha of the lastest commit on the pr branch [ref](https://github.com/orgs/community/discussions/26676)
-  `github.event.pull_request.head.ref`: pr branch name. e.g. `BRANCH: ${{ github.event_name == 'push' && github.ref_name || github.event.pull_request.head.ref }}`: branch name for `push` and `pull_request` event (need to set in `env`)
-  `github.event.number`: pull request number. e.g. `${{ github.event_name == 'push' && github.ref_name || format('pr-{0}', github.event.number) }}` get tag name (branch name for push and `pr-xxx` for pr)

|GitHub Actions|Trigger|Description|
|---|---|---|
|[actionlint](.github/workflows/actionlint.yml)| pull_request | [actionlint](https://github.com/rhysd/actionlint) lint for GitHub Actions workflows|
|[artifact](.github/workflows/artifact.yml)| pull_request | Upload `github-sha.txt` to artifact. Wanted to download if exists but not worked -> commented out.|
|[auto-approve](.github/workflows/auto-approve.yml)|pull_request| If change is under `automatic-approval`, any PR will be automatically approved.|
|[auto-assign](.github/workflows/auto-assign.yml)|pull_request| Set PR author to the assignee when a PR is created.|
|[auto-merge](.github/workflows/auto-merge.yml)|pull_request| If change is under `automatic-merge`, any PR will be automatically merged.|
|[auto-release-when-pr-is-merged](.github/workflows/auto-release-when-pr-is-merged.yml)|pull_request|If a PR is merged, create a draft release (publish a release if there's `release` label) and leave a comment on the PR. |
|[conditional-auto-approve](.github/workflows/conditional-auto-approve.yml)|pull_request|If PR's changed files and changes match `AUTO_APPROVE_ALLOWED_REGEX` and `AUTO_APPROVE_FILE_PATH_REGEX` respectively, the pr will be automatically merged. |
|[check-actions-name](.github/workflows/check-actions-name.yml)|pull_request|Check actions file name and the name in yaml file are same.|
|[context](.github/workflows/context.yml)|pull_request|Echo GitHub context `toJson(github)` for checking.|
|[default-commands](.github/workflows/default-commands.yml)|pull_request|Check default commands (e.g. `zip`, `aws`, `jq`, `yq`)|
|[docker-layer-cache](.github/workflows/docker-layer-cache.yml)|pull_request|Use `satackey/action-docker-layer-caching`.|
|[envvar](.github/workflows/envvar.yml)|pull_request|How to set env var and use it.|
|[keep-only-one-comment-on-pr](.github/workflows/keep-only-one-comment-on-pr.yml)|pull_request|Create a comment if not exist. Otherwise, update the existing comment.|
|[labeler](.github/workflows/labeler.yml)|pull_request|Add `label` to a pr based on the title.|
|[poetry-cache](.github/workflows/poetry-cache.yml)|pull_request|cache poetry and python dependencies managed by poetry.|
|[pre-commit](.github/workflows/pre-commit.yml)|pull_request|Run `pre-commit`.|
|[s3-local](.github/workflows/s3-local.yml)|pull_request|Use `minio` for s3 mock in GitHub Actions. **This workflow is broken❌.**|
|[terrraform-fmt](.github/workflows/terraform-fmt.yml)|pull_request|Run `terraform fmt` for `**.tf`.|
|[changed-files](.github/workflows/changed-files.yml)|pull_request|do sth for changed files/dir using https://github.com/tj-actions/changed-files|

### 2. release

|GitHub Actions|Trigger|Description|
|---|---|---|
|**auto-pr**|release| When a release is published from `main` branch, update a kubernetes yaml file in another repository `nakamasato/k8s-deploy-test` and create a pr in the repository.|
|**prereleased**|release|When release is prereleased from main branch, echo "prereleased".|
|[released](.github/workflows/released.yml)|release|If a release is published from main branch, echo the release version|
|[release-with-environment](.github/workflows/release-with-environment.yml)|release|If a release is published from main branch, the workflow needs to be reviewed.|
|**k8s-ci**|release|Build docker image, push it to Github Packages, and update manifest file.|

### 3. push

-  `BRANCH: ${{ github.event_name == 'push' && github.ref_name || github.event.pull_request.head.ref }}`: branch name for `push` and `pull_request` event (need to set in `env`)

|GitHub Actions|Trigger|Description|
|---|---|---|
|~~**branch-and-tag**~~|push| If change is pushed to `merge` branch or tagged as `v1.*`, the branch will be merged to `main` branch. disabled due to branch protection in [#1348](https://github.com/nakamasato/github-actions-practice/pull/1348)❌|
|**pip-cache**|push|Use `actions/cache` for caching `~/.cache/pip`|
|**pip-no-cache**|push|For comparison with **pip-cache**|
|[python-semantic-release](.github/workflows/python-semantic-release.yml)|push|❌ not compatible with branch protection [ref](https://github.com/semantic-release/github/issues/175)|

### 4. schedule

|GitHub Actions|Trigger|Description|
|---|---|---|
|[schedule](.github/workflows/schedule.yml)|schedule|Echo "test" at 00:00 every Monday.|
|[create-pr-if-outdated](.github/workflows/create-pr-if-outdated.yml)|schedule|create a pr when last update in readme is outdated (create pr with **GitHub App**) ref: [Create GitHub App](https://qiita.com/nakamasato/items/275a687b8d5760d26d65)|

### 5. workflow_dispatch

|GitHub Actions|Trigger|Description|
|---|---|---|
|[workflow-dispatch](.github/workflows/workflow-dispatch.yml)|workflow_dispatch|You can run this workflow from [here](https://github.com/nakamasato/github-actions-practice/actions/workflows/workflow-dispatch.yaml)|

### 6. workflow_call

|GitHub Actions|Trigger|Description|
|---|---|---|
|[print-workflow-dispatch-inputs](.github/workflows/print-workflow-dispatch-inputs.yaml)|workflow_call|You can reuse this workflow to print inputs of workflow_dispatch (inputs: environment & logLevel)|

### 6. [Matrix](https://docs.github.com/en/actions/using-jobs/using-a-matrix-for-your-jobs)

1. `env` cannot be used for matrix.
1. The `matrix` value cannot be used in `if` for its job.
1. `fromJson` is often used to generate `matrix` (ref: https://docs.github.com/en/actions/learn-github-actions/expressions)

|GitHub Actions|Trigger|Description|
|---|---|---|
|[matrix-from-previous-job-output](.github/workflows/matrix-from-previous-job-output.yml)|pull_request|matrix execution from the output of the previous step. `fromJson`|
|[matrix-from-previous-job-output-2](.github/workflows/matrix-from-previous-job-output-2.yml)|pull_request, push|matrix execution from the output of the previous step. `fromJson`|
|[matrix-from-previous-job-output-3](.github/workflows/matrix-from-previous-job-output-3.yml)|pull_request, push| do something for both `prod` and `dev` for `push` event and do sth only for `dev` for `pull_request` event|
|[matrix-by-condition](.github/workflows/matrix-by-condition.yml)|pull_request, push|run for dev and prod when merged to main. run only for dev for pull_request.|

## CheatSheet
- conditional `needs`: you can run `main-job` when `dependent-job` completed successfully or is skipped
    ```yaml
    jobs:
      dependent-job:
        ...
      main-job:
        needs: dependent-job
        if: needs.dependent-job.result == 'success' || needs.dependent-job.result == 'skipped'`
    ```
- Available commands by default ([default-commands.yml](.github/workflows/default-commands.yml))
    - `zip`, `aws`, `jq`, `yq`
    - [gh](https://docs.github.com/en/actions/using-workflows/using-github-cli-in-workflows)

        <details><summary>example</summary>

        ```yaml
        - uses: actions/checkout@v3 # to get the context

        - name: gh
          env:
            GITHUB_TOKEN: ${{ secrets.GITHUB_TOKEN }}
            PR_NUMBER: ${{ github.event.pull_request.number }}
          run: gh pr comment $PR_NUMBER --body "Hi from GitHub CLI"
        ```

        - [default-commands.yml](.github/workflows/default-commands.yml)
        - [create-pr-if-outdated.yml](.github/workflows/create-pr-if-outdated.yml)

        </details>

- [Events to Trigger workflow](https://docs.github.com/en/actions/reference/events-that-trigger-workflows)
    - `pull_request`
        - default types: `opened`, `synchronize`, or `reopened`.
        - specify types:
            ```yaml
            on:
              pull_request:
                types: [assigned, opened, synchronize, reopened, ready_for_review]
            ```
            - action: `${{ github.event.action }}`: You can get `edited`, `synchronize`, `ready_for_review`, (`opened` ❌)
        - Get PR number: `PR_NUMBER=${{ github.event.number }}`
        - Get sha: `${{ github.sha }}`
        - Get repository: `${{ github.repository }}`
        - Get label name for `labeled` type: `${{ github.event.label.name }}`
        - Get source branch: `${{ github.head_ref }}`
        - Get base branch: `${{ github.base_ref }}`
        - Whether the PR is `draft`: `github.event.pull_request.draft`
        - Whether the label is in the whitelist: `if: ${{ github.event.action == 'labeled' && contains(toJson('["test", "build"]'), github.event.label.name) }}`
        - If merged pr has label `release`: `if: ${{ github.event.pull_request.merged == true && contains( github.event.pull_request.labels.*.name, 'release') }}`
        - Whether pull_request has 'test' label: `if: ${{ contains( github.event.pull_request.labels.*.name, 'test') }}`
    - `release`
        - Whether release is from `main` branch: `if: github.event.release.target_commitish == 'main'`
    - `push`
    ...

- [Context](https://docs.github.com/en/actions/reference/context-and-expression-syntax-for-github-actions#contexts)
    - Whether commit message contains `[skip ci]`: (maybe you can also consider using [GitHub Actions: Skip pull request and push workflows with [skip ci]](https://github.blog/changelog/2021-02-08-github-actions-skip-pull-request-and-push-workflows-with-skip-ci/))

        <details>

        ```yaml
        if: contains(github.event.head_commit.message, '[skip ci]') == false
        ```

        </details>
    - Skip draft PR: `if: github.event.pull_request.draft == false`
- [Outputs](https://docs.github.com/en/actions/learn-github-actions/workflow-syntax-for-github-actions#jobsjob_idoutputs)

    - Set output: `echo "<your var name>=<value>" >> "$GITHUB_OUTPUT"`
    - Use output: `${{ steps.<step_id>.outputs.<your var name> }}`
    - Skip next job based on the result of a dependent job

        <details>

        ```yaml
          skipci:
            runs-on: ubuntu-18.04
            outputs:
              is_skip: ${{ steps.is_skip.outputs.is_skip }}
            steps:
              - name: Set is_skip
                id: is_skip
                run: echo "is_skip=${{ contains(github.event.head_commit.message, '[skip ci]') }}" >> "$GITHUB_OUTPUT"
              - run: echo "[skip ci] ${{ steps.is_skip.outputs.is_skip }}"

          test:
            runs-on: ubuntu-18.04
            needs: skipci
            if: ${{ ! needs.skipci.outputs.is_skip }}
            steps:
        ```

        </details>
- [Environment variable](https://docs.github.com/en/actions/learn-github-actions/environment-variables)
    - [default environment variables](https://docs.github.com/en/actions/configuring-and-managing-workflows/using-environment-variables#default-environment-variables)
    - source branch and base brach of PR

        <details>

        ```yaml
        env:
          SOURCE_BRANCH: ${{ github.head_ref }}
          BASE_BRANCH: ${{ github.base_ref }}
        ```

        </details>

- [Environment](https://docs.github.com/en/actions/managing-workflow-runs-and-deployments/managing-deployments/managing-environments-for-deployment)

    ```yaml
    environment:
      name: ${{ github.event_name == 'release' && 'production' || github.event_name == 'push' && 'development' || github.event_name == 'pull_request' && 'pull_request' }}
    ```

    Example: .github/workflows/environment.yaml

- [Caching](https://docs.github.com/en/actions/advanced-guides/caching-dependencies-to-speed-up-workflows)

    - General: [actions/cache](https://github.com/actions/cache)
        - Example: https://github.com/actions/cache/blob/master/examples.md
    - Ruby: [ruby/setup-ruby](https://github.com/ruby/setup-ruby#caching-bundle-install-automatically)
    - npm: [actions/setup-node](https://github.com/actions/setup-node)
    - Go: [actions/setup-go](https://github.com/actions/setup-go) enabled by default since v4
        - [github actionsのsetup-goのキャッシュは無効にした方がいいかもしれない](https://zenn.dev/goryudyuma/articles/f387dba8838ff7)
        - cache key is `setup-go-${platform}-go-${versionSpec}-${fileHash}` https://github.com/actions/setup-go@v4.0.0/src/cache-restore.ts#L32
        - `hash-dependency-path` `go.mod` by default (https://github.com/actions/setup-go#caching-dependency-files-and-build-outputs)
    - Gradle and Maven: [actions/setup-java](https://github.com/actions/setup-java)
    - [Python - pip](https://github.com/actions/cache/blob/master/examples.md#python---pip)
        <details>

        - Case1: No cache:
            - pip install: 14s
        - Case2: With cache:
            - action/cache: 3s
            - pip install: 0s (skipped)
            - action/cache: 0s (skipped)

        </details>
    - [Docker Layer Cache](https://github.com/marketplace/actions/docker-layer-caching)

        <details>

        Example Docker image:
        - Case1: No cache:
            - Build Docker image: 3m 13s
        - Case2: with cache but couldn't use layer cache:
            - Run satackey/action-docker-layer-caching@v0.0.8: 2m 30s
            - Build Docker image: 3m10s
            - Run satackey/action-docker-layer-caching@v0.0.8: 3m 58s
        - Case3: with cache and all the layers could use cache:
            - Run satackey/action-docker-layer-caching@v0.0.8: 3m 48s
            - Build Docker image: 1s
            - Run satackey/action-docker-layer-caching@v0.0.8: 3m 40s
        </details>

        In some case, no cache might be rather faster due to the time to spend storing and restoring a cache.
- Failure

    <details>

    ```yaml
    name: status

    on: pull_request

    jobs:
      just-fail:
        if: github.event.pull_request.draft == true
        runs-on: ubuntu-latest
        steps:
          - id: fail_step
            run: exit 1

          - run: echo ${{ steps.fail_step.outcome }} # not called

      fail-with-post-process:
        if: github.event.pull_request.draft == true
        runs-on: ubuntu-latest
        steps:
          - id: fail_step
            continue-on-error: true
            run: exit 1

          - name: post process regardless of sucess or failure
            run: echo ${{ steps.fail_step.outcome }} # failure

          - name: make it fail when the first step failed
            if: steps.fail_step.outcome == 'failure'
            run: exit 1

      succeed-with-post-process:
        if: github.event.pull_request.draft == true
        runs-on: ubuntu-latest
        steps:
          - id: succeed_step
            continue-on-error: true
            run: echo succeed

          - name: post process regardless of sucess or failure
            run: echo ${{ steps.fail_step.outcome }} # success

          - name: make it fail when the first step failed
            if: steps.fail_step.outcome == 'failure'
            run: exit 1

      fail-with-post-process-for-failure:
        if: github.event.pull_request.draft == true
        runs-on: ubuntu-latest
        steps:
          - id: fail_step
            run: exit 1

          - if: failure()
            name: post process only called when the first step fails
            run: echo ${{ steps.fail_step.outcome }} # failure

      succeed-with-post-process-for-failure:
        if: github.event.pull_request.draft == true
        runs-on: ubuntu-latest
        steps:
          - id: succeed_step
            run: echo succeed

          - if: failure()
            name: post process only called when the first step fails
            run: echo ${{ steps.fail_step.outcome }}

      succeed:
        runs-on: ubuntu-latest
        steps:
          - id: suceed_step
            continue-on-error: true
            run: echo succeed

          - run: echo ${{ steps.suceed_step.outcome }} # success

          - if: steps.fail_step.outcome == 'failure'
            run: exit 1
    ```

    </details>

- Example
    - Test mvn with MySQL

        <details>

        ```yaml
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

        </details>

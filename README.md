# github-actions-practice

## Github Actions Table
|GitHub Actions|Trigger|Description|
|---|---|---|
|**artifact**| pull_request | Upload `github-sha.txt` to artifact. Wanted to download if exists but not worked -> commented out.|
|**auto-approve**|pull_request| If change is under `automatic-approval`, any PR will be automatically approved.|
|**auto-assign**|pull_request| Set PR author to the assignee when a PR is created.|
|**auto-merge**|pull_request| If change is under `automatic-merge`, any PR will be automatically merged.|
|**auto-pr**|release| When a release is published from `master` branch, update a kubernetes yaml file in another repository `nakamasato/k8s-deploy-test` and create a pr in the repository.|
|**branch-and-tag**|push| If change is pushed to `merge` branch or tagged as `v1.*`, the branch will be merged to `master` branch.|
|[conditional-auto-approve](.github/workflows/conditional-auto-approve.yml)|pull_request|If PR's changed files and changes match `AUTO_APPROVE_ALLOWED_REGEX` and `AUTO_APPROVE_FILE_PATH_REGEX` respectively, the pr will be automatically merged. |
|**context**|pull_request|Echo GitHub context `toJson(github)` for checking.|
|**default-commands**|pull_request|Check default commands (e.g. `zip`, `aws`, `jq`)|
|**docker-layer-cache**|pull_request|Use `satackey/action-docker-layer-caching`.|
|**envvar**|pull_request|How to set env var and use it.|
|**labeler**|pull_request|Add `label` to a pr based on the title.|
|**pip-cache**|push|Use `actions/cache` for caching `~/.cache/pip`|
|**pip-no-cache**|push|For comparison with **pip-cache**|
|**pre-commit**|pull_request|Run `pre-commit`.|
|**prereleased**|release|When release is prereleased from master branch, echo "prereleased".|
|**pull-request**|pull_request|If a PR is merged, create a release. If a PR is not merged, echo "Pull Request".|
|**released**|release|If a release is published from master branch, push a commit to `master` branch.|
|**s3-local**|pull_request|Use `minio` for s3 mock in GitHub Actions.|
|**schedule**|schedule|Echo "test" at 00:00 every Monday.|
|**terrraform_fmt**|pull_request|Run `terraform fmt` for `**.tf`.|

## CheatSheet
- Available commands by default ([default-commands.yml](.github/workflows/default-commands.yml))
    - `zip`, `aws`, `jq`
- [Events to Trigger workflow](https://docs.github.com/en/actions/reference/events-that-trigger-workflows)
    - `pull_request`
        activity type: `opened`, `synchronize`, or `reopened`.
        - specify types:
            ```yaml
            on:
              pull_request:
                types: [assigned, opened, synchronize, reopened, ready_for_review]
            ```
        - Get PR number: `PR_NUMBER=${{ github.event.number }}`
        - Get sha: `${{ github.sha }}`
        - Get repository: `${{ github.repository }}`
        - Get label name for `labeled` type: `${{ github.event.label.name }}`
        - Get source branch: `${{ github.head_ref }}`
        - Get base branch: `${{ github.base_ref }}`
        - Whether the PR is `draft`: `github.event.pull_request.draft`
        - Whether the label is in the whitelist: `if: ${{ github.event.action == 'labeled' && contains(toJson('["test", "build"]'), github.event.label.name) }}`
    - `release`
        - Whether release is from `master` branch: `if: github.event.release.target_commitish == 'master'`
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

    - Set output: `echo "::set-output name=<your var name>::<value>"`
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
                run: echo "::set-output name=is_skip::${{ contains(github.event.head_commit.message, '[skip ci]') }}"
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


- [Caching](https://docs.github.com/en/actions/advanced-guides/caching-dependencies-to-speed-up-workflows)

    - General: [actions/cache](https://github.com/actions/cache)
        - Example: https://github.com/actions/cache/blob/master/examples.md
    - Ruby: [ruby/setup-ruby](https://github.com/ruby/setup-ruby#caching-bundle-install-automatically)
    - npm: [actions/setup-node](https://github.com/actions/setup-node)
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

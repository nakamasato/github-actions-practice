module.exports = ({ github, context }) => {
    const output = `#### Terraform Format and Style 🖌\`${process.env.FMT}\`
#### Terraform Initialization ⚙️\`${process.env.INIT}\`
#### Terraform Validation 🤖${process.env.VALIDATION}
#### Terraform Plan 📖\`${process.env.PLAN}\`
<details><summary>Show Plan</summary>

\`\`\`${process.env.PLAN}\`\`\`

</details>
*Pusher: @${context.actor}, Action: \`${context.eventName}\`, Working Directory: \`${process.env.ENV_FOR_JOB}\`, Workflow: \`${context.workflow}\`*`;

    github.rest.issues.createComment({
        issue_number: context.issue.number,
        owner: context.repo.owner,
        repo: context.repo.repo,
        body: output
    })
}

module.exports = ({ github, context }) => {
    return context.payload.client_payload.value
}


// module.exports = ({ github, context }) => {
//     const output = `*Pusher: @${github.actor}, Action: \`${github.event_name}\`, Working Directory: \`${env.tf_actions_working_dir}\`, Workflow: \`${github.workflow}\`*`;
//     github.issues.createComment({
//         issue_number: context.issue.number,
//         owner: context.repo.owner,
//         repo: context.repo.repo,
//         body: output
//     })
// }

// const output = `#### Terraform Format and Style 🖌\`${steps.fmt.outcome }\`
// #### Terraform Initialization ⚙️\`${ steps.init.outcome }\`
// #### Terraform Validation 🤖${ steps.validate.outputs.stdout }
// #### Terraform Plan 📖\`${ steps.plan.outcome }\`
// <details><summary>Show Plan</summary>

// \`\`\`${ process.env.PLAN }\`\`\`

// </details>
// *Pusher: @${ github.actor }, Action: \`${ github.event_name }\`, Working Directory: \`${ env.tf_actions_working_dir }\`, Workflow: \`${ github.workflow }\`*`;

// github.issues.createComment({
//   issue_number: context.issue.number,
//   owner: context.repo.owner,
//   repo: context.repo.repo,
//   body: output
// })

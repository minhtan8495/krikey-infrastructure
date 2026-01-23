# krikey-Terraform
krikey AWS Infrastructure in Terraform

## Tech stacks
1. terraform
2. hashicorp/aws

## Environment setup

1. Configure AWS credentials

  - Install AWS cli
  https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html

  - Run `aws configure` to create AWS profile and input aws accessKey & secretKey

2. Install terraform cli(https://learn.hashicorp.com/tutorials/terraform/install-cli)

3. Add Github Connection to AWS(from here https://us-east-1.console.aws.amazon.com/codesuite/settings/connections?region=us-east-1)

4. Replace codestar_connection_arn with your codestar connection arn in `dev/terraform.tfvars`.

5. Update `frontend_branch_name`, `backend_branch_name` with branch name which you want to deploy

  - For development

    `frontend_branch_name`: dev

    `backend_branch_name`: dev

## Deploy Infrastructure

  - Goto dev directory `cd ./dev`
  - Initialize terraform by running `terraform init`
  - Deploy terraform by running `terraform apply`

Terraform deploy will occur the backend & frontend deployments automatically by AWS CodePipeline.

# Project Templating Advanced Example

This example demonstrates an advanced use case of project templating in 
HashiCorp Waypoint. The deployment resources created by the templated Waypoint 
ECS deployment plugin configuration, accompanied by the day zero 
organization-level infrastructure configuration, and the application-level
resources provided by the Terraform No Code module in the project template, 
demonstrate how project templating is used to enable developers to launch their
new applications in a production-ready state. This includes:

- Version control (code repository)
- Immediately buildable template application code
- Continuous Integration
- Application runtime
- Static & dynamic secrets
- Data store
- Telemetry

The day zero organization-level infrastructure includes resources that are 
shared across many applications within an organization. For the organization
depicted in this example, that includes:

1. AWS networking and security infrastructure (VPCs, security groups, subnets,
and more) for two independent environments: "dev" and "prod"
2. AWS Elastic Container Service (ECS) clusters for shared "dev" and "prod" 
environments
3. HashiCorp Vault clusters for shared "dev" and "prod" environments
   - These clusters are hosted in HashiCorp Cloud Platform (HCP)
4. Peering connection between AWS network infrastructure and HCP Vault
5. AWS Open ID connect (OIDC) configuration for GitHub Actions to authenticate
to AWS elastic container registry (ECR)
6. DataDog integration with AWS
7. AWS identity access management (IAM) resources to enable Waypoint to 
authenticate to Vault via the AWS auth method for application secrets

<!--- TODO: include GitHub organization, template Go repo, Terraform Cloud resources --->

With the organization-level infrastructure created, project templates enable
developers to immediately start deploying their new apps to that infrastructure.
When rendered, the project template in this example provisions a Terraform No
Code workspace using a module that creates application-level resources, 
including:

1. AWS application load balancer (ALB) in "dev" and "prod" environments
2. AWS ECR in "prod" environment
3. AWS IAM task and execution roles
4. AWS security groups
5. GitHub repository with template code for a Go gRPC server application which
also connects to a Postgres database, as well as GitHub Actions (GHA) 
configuration for continuous integration and deployment (CI/CD)
   - This GitHub repository is "rendered" using a Terraform local provisioner, 
substituting in variables for tokenized values in the template repository
6. GitHub environment with secrets for CI/CD
7. AWS IAM role and policy to enable pushing images to ECR from CI/CD in GHA
8. AWS relational database service (RDS) Postgres database instances for "dev"
and "prod" environments
9. Vault database secrets engine and policies in "dev" and "prod" clusters for
dynamic database secrets
10. Vault AWS auth method configuration to enable Waypoint to authenticate to
Vault via AWS for application secrets
11. Vault key-value (KV) secrets engine configuration and secrets for static app
configuration
12. DataDog dashboards and monitors

## Pre-Requisites
1. Terraform Cloud (TFC) account
2. HCP account
3. GitHub account
4. A template GitHub repository 
5. DataDog account
6. AWS Account

<!--- TODO: Add location of the Go protobuf template to use --->

## Using this example

### Platform Engineer

1. Apply the Terraform configuration in the `terraform-org-day-zero-infra` path
2. Install a Waypoint runner to the "prod" ECS cluster created in step 1
    - `waypoint runner install -platform=ecs -ecs-region=us-east-2 -ecs-cluster=$(terraform output -json ecs_cluster_name | jq -r .prod)`
    - Note: Your terminal should be authenticated to AWS with the necessary permissions to create runner resources
3. Apply the Terraform configuration in the `terraform-vault` path
4. Set the following credentials in a Terraform Cloud (TFC) global or project-scoped 
variable set in TFC:
   - Environment variables:
     - AWS_ACCESS_KEY_ID
     - AWS_SECRET_ACCESS_KEY
     - AWS_SESSION_EXPIRATION
     - AWS_SESSION_TOKEN
   - Terraform variables:
     - aws_account_id
     - aws_region
     - datadog_api_key
     - datadog_app_key
     - day_zero_infra_tfc_workspace_name
     - dev_vault_token
     - dev_vault_address
     - waypoint_address
     - waypoint_token
     - git_email
     - git_user
     - github_repo_owner
     - github_token
     - prod_vault_address
     - prod_vault_token
     - vault_tfc_workspace_name
5. Create a Waypoint template
   - `waypoint template create`
6. Create a TFC config source
    - The token must have permissions to READ outputs from the No Code workspaces
    - ```shell
      waypoint config source-set -type=terraform-cloud \
      -config=token=<TFC_TOKEN>
      ```
7. Create a [Vault config source](
https://developer.hashicorp.com/waypoint/integrations/hashicorp/vault/latest/components/config-sourcer/vault-config-sourcer
) for the dev and prod workspaces
   - ```shell
     waypoint config source-set -type=vault \
     -workspace=dev \
     -config=addr=<DEV_VAULT_URL> \
     -config=auth_method=aws \
     -config=aws_type=iam \
     -config=aws_role=app`
     ```
   - ```shell
     waypoint config source-set -type=vault
     -workspace=prod \ 
     -config=addr=<PROD_VAULT_URL> \
     -config=auth_method=aws \
     -config=aws_type=iam \
     -config=aws_role=app`
     ```

### App Developer
1. In the HCP Waypoint UI, click New Project
2. Select `Create Project With Template` option
3. Select Go Postgres template
4. Name your app, click create
5. Wait for Terraform
6. Update project settings with GitHub repo information
7. Push new commit to branch, merge to main
8. Watch GitHub Action 
9. Check project in HCP to see deployment

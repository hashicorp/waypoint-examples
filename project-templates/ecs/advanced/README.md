# Project Templating Advanced Example

## Overview

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

## The Manual

This manual will describe the steps necessary to render the project template
for a new Go gRPC server application. They will be broken up into two personas
who will use project templating in Waypoint: the platform engineer and the app
developer. The platform engineer sets up the org-level infrastructure, 
Terraform Cloud configurations, Waypoint project template, Waypoint runners, 
and the Terraform Cloud config sourcer plugin configuration. The app developer
creates a new project from a template, providing the new application's name to
Waypoint, and then starts developing!

### Pre-Requisites
1. Terraform Cloud (TFC) account
2. HCP account
3. A Waypoint context configured to use HCP Waypoint
4. GitHub account
5. A template GitHub repository 
6. DataDog account
7. AWS Account
8. `grpcurl` tool

<!--- TODO: Add location of the Go protobuf template to use --->

### Platform Engineer

1. Fork the [Go template app repository](https://github.com/hashicorp/waypoint-template-go-protobuf-api) into your GitHub organization.
2. Fork the [Terraform No Code module](https://github.com/hashicorp/terraform-aws-ecs-advanced-microservice) into your GitHub organization.
3. In the following two files, update the `organization` field inside the `cloud`
block of the `terraform` block to be your Terraform Cloud organization name.
   - `./terraform-org-day-zero-infra/terraform.tf`
   - `./terraform-vault/terraform.tf`
4. Apply the Terraform configuration in the `terraform-org-day-zero-infra` path
of this example.
    - `terraform init` and then `terraform apply`
    - You will need to provide input to the variables without default values.
5. Install a Waypoint runner to the "prod" ECS cluster created in step 4.
    - `waypoint runner install -platform=ecs -ecs-region=us-east-2 -ecs-cluster=$(terraform output -json ecs_cluster_name | jq -r .prod)`
    - Note: Your terminal should be authenticated to AWS with the necessary permissions to create runner resources.
6. Apply the Terraform configuration in the `terraform-vault` path.
    - `terraform init` and then `terraform apply`
    - The org-level resources in Vault are created in a separate workspace 
    because the Vault clusters are created during the `apply` in step 4, and 
    the Vault provider cannot be supplied configuration/credentials before the
    clusters are up and running.
7. Set the following credentials in a Terraform Cloud (TFC) global or project-scoped 
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
8. Publish the Terraform No Code module in your private TFC module registry.
   - [Instructions on publishing a No Code module](https://developer.hashicorp.com/terraform/tutorials/cloud/no-code-provisioning#publish-no-code-ready-module)
   - Publish one git tag of the module, `v1.0.0`
9. Create a Waypoint project template, using the:
   - No Code module
     - ![template-1.png](readme-images%2Ftemplate-1.png)
   - Waypoint configuration template `waypoint.hcl.tpl`
   - README markdown template `README.md.tpl`
   - Short summary
      ```text
     A project template for Go microservices which creates dev and prod 
     environments. These environments run on AWS ECS.
     ```
   - Long summary
      ```text
     A project template for Go gRPC server microservices. Projects created from
     this template will have GitHub repository with Go code and protocol buffers
     generated. The app in the repo will also have an RPC written to connect to
     a Postgres database. The repo will also contain GitHub Actions workflow
     configuration to build the app and run tests, build the app in a Docker 
     container, and push the container to ECR. On merges to main, a workflow
     runs to deploy to the dev environment.

     Project name requirements:
     - Must begin with a capital letter
     - Must not contain any non-alphanumeric characters
     - Must not be more than 20 characters long
     ```
   - ![template-2.png](readme-images%2Ftemplate-2.png)
10. Set TFC configs in the HCP Waypoint UI. This configuration enables HCP 
Waypoint to provision a No Code workspace when a project is created from a
template.
     - ![tfc-config.png](readme-images%2Ftfc-config.png)
11. Create a [TFC config source](https://developer.hashicorp.com/waypoint/integrations/hashicorp/terraform-cloud/latest/components/config-sourcer/terraform-cloud-config-sourcer).
     - The token must have permissions to READ outputs from the No Code workspaces
     in your default TFC project
     - ```shell
       waypoint config source-set -type=terraform-cloud \
       -config=token=<TFC_TOKEN> \
       -scope=global
       ```
12. Create a [Vault config source](
   https://developer.hashicorp.com/waypoint/integrations/hashicorp/vault/latest/components/config-sourcer/vault-config-sourcer) 
   for the dev and prod workspaces:
   - ```shell
     waypoint config source-set -type=vault
     -workspace=dev \ 
     -config=addr=<DEV_VAULT_URL> \
     -config=token=<VAULT_TOKEN> \
     -config=namespace=admin
     ```
   - ```shell
     waypoint config source-set -type=vault
     -workspace=prod \ 
     -config=addr=<PROD_VAULT_URL> \
     -config=token=<VAULT_TOKEN> \
     -config=namespace=admin
     ```
 - Note: The Vault token must have permissions to read from the KV secrets
   engine, and create dynamic secrets in the DB secrets engine
 - Note: "admin" is the name of the first namespace in an HCP Vault cluster
    
 <!--- TODO: Use AWS auth method since the app will run in AWS ECS. 
 Ideally, this is in the No Code module, and not done here at all.
- ```shell
  waypoint config source-set -type=vault \
  -workspace=dev \
  -config=addr=<DEV_VAULT_URL> \
  -config=auth_method=aws \
  -config=aws_type=iam \
  -config=aws_role=app \
  -config=namespace=admin
  ```
- ```shell
  waypoint config source-set -type=vault
  -workspace=prod \ 
  -config=addr=<PROD_VAULT_URL> \
  -config=auth_method=aws \
  -config=aws_type=iam \
  -config=aws_role=app \
  -config=namespace=admin
  ```
 --->

<!--- TODO: Problem here - Vault config source setup should be done via the 
Waypoint Terraform provider - it's easy to miss, but these config sources
actually rely on app-scoped resources; we don't want the dev to have to set
this up after their project is rendered, and the platform engineer doesn't 
actually know the aws_role name til the project is rendered, so we're making
an assumption here --->

With all the base organization infrastructure created and the project 
template configured, it's time for the app developer to render their project!

### App Developer
1. In the HCP Waypoint UI, click New Project.
2. Select `Create Project With Template` option.
3. Select `go_grpc_postgres_micro`.
    - ![template-select.png](readme-images%2Ftemplate-select.png)
4. Name your app `TheMicroservice`, then click create.
    - ![project-create.png](readme-images%2Fproject-create.png)
    - Monitor the project detail page to check Terraform run status
5. Update project settings with GitHub repo information
    - This informs Waypoint about from where to get the app source code at 
    build/deploy time

7. Go to the newly created GitHub repository, and create a new branch.
8. Monitor the GHA workflow that ran to see:
    - `go build` and `go test` running against the new app
    - `docker build` running to build a container image for the app, and push
    to AWS ECR
    - `waypoint` build running for `dev` and `prod` workspaces, which sets up
    Waypoint to deploy the just-build images pushed to ECR at deploy time
9. Check project in HCP UI to see build details.
10. Make some changes to the new branch. When satisfied, merge the branch to 
`main`.
11. Monitor GHA running the "deploy" workflow, which deploys the app container
image to the `dev` environment.
12. Promote the deployment to production.
    - `waypoint deploy -workspace=prod -p=TheMicroservice -a=TheMicroservice -remote-source=ref=<GIT_COMMIT_ID>`
    - The Git commit ID should be the ID of the commit from the `waypoint build`
    run by GitHub Actions.
13. Access the application using `grpcurl`.
    - `grpcurl -insecure <HOSTNAME>:443 list` will show the available services
    exposed by the server.
      - Expected response:
        ```
        TheMicroservice.v1.TheMicroserviceService
        grpc.health.v1.Health
        grpc.reflection.v1alpha.ServerReflection
        ```
    - The hostname to use is output by Waypoint at the conclusion of running
    `waypoint deploy`, and will resemble (do not include `http`):
```
The deploy was successful! This deploy was done in-place so the deployment
URL may match a previous deployment.

Release URL: http://themicroservice-prod-1234567890.us-east-2.elb.amazonaws.com
```

<!--- TODO: Demonstrate `waypoint logs`, show DB connectivity --->

<!--- TODO: Add steps to help the developer connect to dev, since dev is 
inaccessible from the public internet --->

<!--- TODO: Create a new GHA workflow for prod release --->

<!--- TODO: Add UI screenshots --->

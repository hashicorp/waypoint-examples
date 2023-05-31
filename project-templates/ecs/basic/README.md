# HCP Waypoint Project Template Example


This is an example of how a platform engineer can create a project template in HCP Waypoint to allow application developers to quickly bootstrap new applications following organizational standards.

Project Templates in HCP Waypoint allow platform engineers to define templates for waypoint projects. Templates contain a templated waypoint.hcl, which defines the app's deployment workflow, and a Terraform [no-code module](https://developer.hashicorp.com/terraform/tutorials/cloud/no-code-provisioning) which creates app-specific infrastructure. App developers can then create new applications using this template quickly and easily, without needing deep awareness of the underlying infrastructure.

In this example, we will configure a project template for AWS ECS microservices with dev and prod environments, and then use it to create and deploy a basic nodejs webapp.

Pre-Requisites:

- AWS Account with Admin Permissions

- Terraform Enterprise Account with No Code Module Enabled.

## Foundational Infrastructure Setup

### Terraform Cloud Workspaces

1. (CLI-driven only) Create terraform cloud [workspaces](https://developer.hashicorp.com/terraform/cloud-docs/workspaces/creating) in the TFC User Interface based on the following terraform configurations provided in this example:
   `terraform-aws-example-microservice-infra`
   `terraform-aws-example-network`
   ![img_9.png](../readme-images/create_tfc_workspace_ss.png)


2. Go to Settings for the created TFC workspaces, Under `Remote State Sharing` allow `Share with all workspaces in this organization`.
   ![img_10.png](../readme-images/tfc_remote_sharing_ss.png)


3. Create a [global variable set](https://developer.hashicorp.com/terraform/tutorials/cloud-get-started/cloud-workspace-create#create-the-workspace) for your AWS Credentials.

### AWS Steps with Terraform

Create the baseline infrastructure with the following steps in your CLI.

1. Navigate to the `terraform-aws-example-network` directory found in this example and run `terraform init` and the `terraform apply` command.

2. Navigate to the `terraform-aws-example-microservice-infra` directory found in this example and run `terraform init` and the  `terraform apply` command.


### Terraform Module Creation
Now that we've created the base shared infrastructure, we can move on to app-specific infrastructure.

Most applications need some long-lived infrastructure, like a container registry and a load balancer. This module gives platform engineers a space to define this app-specific infrastructure for their specific organization.
Now that we've created the base shared infrastructure, we can move on to app-specific infrastructure.

Most applications need some long-lived infrastructure, like a container registry and a load balancer. This module gives platform engineers a space to define this app-specific infrastructure for their specific organization.

This example extends Waypoint's [ecs module](https://registry.terraform.io/modules/hashicorp/waypoint-ecs/aws/latest) to create a single global container registry, and resources like an ALB, security group, and IAM role in the dev and prod environments.

This module is an opportunity for platform engineers to get creative and define any other app-specific infrastructure, like  monitoring dashboards or tickets in a ticketing system. 
This example extends Waypoint's [ecs module](https://registry.terraform.io/modules/hashicorp/waypoint-ecs/aws/latest) to create a single global container registry, and resources like an ALB, security group, and IAM role in the dev and prod environments.

This module is an opportunity for platform engineers to get creative and define any other app-specific infrastructure, like  monitoring dashboards or tickets in a ticketing system. 
TODO(Teresa): Make this repo public.

1. Fork the `hashicorp/terraform-aws-example-microservice-ecs-all-envs` repository in Github [here](https://github.com/hashicorp/terraform-aws-example-microservice-ecs-allenvs) to your own Github organization.

2. Run the following git commands in the forked repository's working directory.

```shell
git tag v.0.0.1
git push --tags
```

#### Publish The Example Module
1. Inside Terraform Cloud, Click Registry and Select `Publish a Module`
![img.png](../readme-images/tfc_publish_module_ss.png)


2. Select Github under `Version Control Provider`

![img_1.png](../readme-images/publish_module_vcs_ss.png)

3. Select your forked repository of the no-code module created in the last step.

![img_2.png](../readme-images/select_repo_ss.png)

4. Click `Publish Module`

![img_3.png](../readme-images/publish_module.png)

5. Review the published module details

![img_4.png](../readme-images/review_module_details.png)



![img_8.png](../readme-images/tfc_registry_ss.png)

Before you start working with Waypoint and creating a template, you need some foundational infrastructure. This example provides a few basic terraform modules for creating AWS VPCs and ECS clusters in dev and prod environments.

If you already have this infrastructure configured, you can jump ahead to [Terraform Module Creation](### Terraform Module Creation) and modify the module to run on your own base infrastructure.
## Waypoint Template Steps 

TODO(Teresa): Replace figma images with proper screenshots once UI is ready.


1. Set up your TFC Credentials in Waypoint. You will need a TFC team access token found in Terraform Cloud and your TFC Organization Name.
![img.png](../readme-images/waypoint_tfc_creds_setup_ss.png)


2. Create a Waypoint Project Template by filling in the fields in the Template Creation page:

Your project template will be utilized to generate the `waypoint.hcl` for developers to start off their projects with. This template will contain
Terraform details that will be used to spin up resources that will be used for application deployment. Please see the following example project
template: 

```shell
// this is the simple example for now
project = "{{ .ProjectName }}"

app "{{ .ProjectName }}" {
Now that you have the basic shared infrastructure set up and a no-code module published with app-specific infrastructure, you can configure HCP Waypoint to authorize to TFC and create a Waypoint project template.
  build {
    use "pack" {}

    registry {
      use "aws-ecr" {
        region     = var.tfc_infra.dev.region
        repository = var.tfc_infra.dev.ecr_repository_name
        tag        = gitrefpretty()
      }
    }
  }

  deploy {
Now that you have the basic shared infrastructure set up and a no-code module published with app-specific infrastructure, you can configure HCP Waypoint to authorize to TFC and create a Waypoint project template.
    # Default workspace deploys to dev
    use "aws-ecs" {
      count = 1
      memory = 512
      cpu = 256
   
      cluster             = var.tfc_infra.dev.ecs_cluster_name
      log_group           = var.tfc_infra.dev.log_group_name
      region              = var.tfc_infra.dev.region
    }
  }
}

variable "tfc_infra" {
  default = dynamic("terraform-cloud", {
    organization = "{{ .TfcOrgName }}"
    workspace    = "{{ .ProjectName }}"
  })
  type        = any
  sensitive   = false
  description = "all outputs from this app's tfc workspace"
}
```

![img_1.png](../readme-images/waypoint_create_template_ss.png)



3. Return to your Projects List Page, and notice your newly created template. Application developers can now use this template to bootstrap new applications!

### Create a waypoint project from a template

Next, you will test the application developer workflow by creating a new sample project from this template. 

1: From the project template list view, in the top right corner, select `Create Project`. From the dropdown menu, select `Create Project with template`:
![img_3.png](../readme-images/waypoint_projects_list_ss.png)

   
4. Select the newly created <name> template
![img_4.png](../readme-images/waypoint_select_template_ss.png)
 
   

5. Type `project-outstanding-panda` under `Project Name`. Then click `Create Project`.
NOTE: Clicking the `Create Project` button will trigger a run on Terraform Cloud. Please note
that this page wil

![img_6.png](../readme-images/waypoint_create_project_ss.png)

   
6. Review the project details of your newly created project! You're Ready to Go!
![img_7.png](../readme-images/waypoint_project_details_ss.png)


## Deploying and Release an Application

Pre-Requisites

1. A HCP Waypoint Account with a runner installed.

After the above steps have been completed, you are now ready to deploy your application.
For the purposes of this example, we will be using the nodejs project that is included in this directory: `project-outstanding-panda`.

1. In your CLI, navigate to the location of the `project-outstanding-panda`
2. Perform the following waypoint command:
```shell
waypoint up -p project-outstanding-panda
```
3. You can now navigate back to HCP Waypoint in your browser and see that the project has been deployed.
![img.png](../readme-images/waypoint_project_deployed_ss.png)

4. You're All Done! Your project is now deployed.


## Conclusion

You've just completed the Waypoint Project Templating example! Congratulations! 
You are now able to set up a project template for your application developers which will allow a seamless application deployment process. 



## Waypoint Template Steps via CURL commands

Pre-Requisites
1. Your Namespace ID
2. HCP Waypoint Authentication Token
3. TFC Authentication Token



1. Set up your TFC Credentials in Waypoint

```shell
curl --location --request PUT 'https:// api.hashicorp.cloud:443/waypoint/2022-02-03/namespace/{{NAMESPACE_ID}}/tfcconfig' \
--header 'Authorization: {{YOUR_HCP_Waypoint_AUTH_TOKEN}}' \
--header 'Content-Type: application/json' \
--data '{"tfc_config":{"organization_name":"hcp_waypoint_integration", "token":"{{YOUR_TFC_AUTH_TOKEN}}"}, "namespace_id":"{{NAMESPACE_ID}}"}'


```

2. Create a Waypoint Project Template

```shell
curl --location 'https:// api.hashicorp.cloud:443/waypoint/2022-02-03/namespace/{{NAMESPACE_ID}}/project-template' \
--header 'Authorization: {{YOUR_HCP_Waypoint_AUTH_TOKEN}}' \
--header 'Content-Type: application/json' \
--data '{
  "project_template": {
    "name": "panda-first-template",
    "summary": "This is the template for panda projects",
    "readme_markdown_template": "{{ENCODED_README_MARKDOWN_BASE64_BYTES}}",
    "waypoint_project": {
      "waypoint_hcl_template": "{{ENCODED_PROJECT_TEMPLATE_BASE64_BYTES}}"
    },
    "terraform_nocode_module": {
      "source": "private/hcp_waypoint_integration/example-microservice-ecs-allenvs/aws",
      "version": "0.1.2"
    }
  }
}'
```


3. Initialize a Waypoint Project Using the Existing Project Template.

```shell
curl --location 'https:// api.hashicorp.cloud:443/waypoint/2022-02-03/namespace/{{NAMESPACE_ID}}/project/from-template' \
--header 'Authorization: Bearer {{YOUR_HCP_Waypoint_AUTH_TOKEN}}' \
--header 'Content-Type: application/json' \
--data '{
  "project_name": "project-outstanding-panda",
  "project_template": {
    "name": "panda-first-template"
  }
}'
```


4. List all Project Templates
```shell
curl --location 'https:// api.hashicorp.cloud:443/waypoint/2022-02-03/namespace/{{NAMESPACE_ID}}/project-templates' \
--header 'Authorization: Bearer {{YOUR_HCP_Waypoint_AUTH_TOKEN}}'
```
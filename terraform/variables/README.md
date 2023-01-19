# Terraform Variables Example

|Title| Description                                                                          |
|---|--------------------------------------------------------------------------------------|
|Pack| Docker                                                                               |
|Cloud| Local                                                                                |
|Language| n/a                                                                                  |
|Docs| [Terraform Cloud](https://developer.hashicorp.com/waypoint/plugins/terraform-cloud)                     |

This example demonstrates sourcing output variables from Terraform Cloud for use in a Waypoint config.

For example, it's possible to create resources like AWS VPCs, AWS/ECS clusters, and subnets in Terraform,
define them as Terraform outputs, and then reference them directly in a Waypoint config.

This example is intended to be a minimalist demonstration of referencing Terraform outputs, not a full
real-world use-case. It creates static Terraform output variables of various types (string, list, and map), and then references
them in local Docker deployment config.

## Terraform Setup

### Org and Workspace Creation

First, we'll need a Terraform Cloud workspace. If you don't have one already, you can create one
using the Terraform found in `terraform/tfc`. If you already have a Terraform org and workspace,
skip ahead to the next section.

This module requires three inputs:

- A TFC API token. Follow [this guide](https://developer.hashicorp.com/terraform/cloud-docs/users-teams-organizations/api-tokens)
to obtain a TFC api token.

- A TFC organization name. This is arbitrary, but needs to be globally unique.

- An email address to use as your TFC org admin contact address.

Run Terraform to create the TFC org and workspace. You'll be prompted for the above inputs

```shell
$ cd ./terraform/tfc
$ terraform init
...
$ terraform apply
...
Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
```

### Generating Terraform Outputs

In `terraform/main`, we have the minimal possible Terraform to generate ouputs. This is meant to simulate
real Terraform that might be creating and AWS VPC, and outputting things like VPC IDs and subnet arns.

You'll need the following inputs:

- An org ID and workspace ID. These cannot be referenced as variables, so you'll need to modify 
`./terraform/main/main.tf`. Use the organization name chosen in the previous step, or set this
to your own organization ID if desired.

```hcl
terraform {
  cloud {
    organization = "waypoint_tfc_vars_example" // <- you must change this

    workspaces {
      name = "waypoint_tfc_vars_example"
    }
  }
}
```

Run the Terraform to produce the outputs:
```shell
$ cd ./terraform/main
$ terraform init
...
$ terraform apply
...
Apply complete! Resources: 0 added, 0 changed, 0 destroyed.

Outputs:

list_of_strings = [
  "item_1",
  "item_2",
  "item_3",
]
map_of_strings = {
  "key1" = "value1"
  "key2" = "value2"
}
simple_string = "justastring"
```

## Waypoint setup

#### Waypoint CLI

Install the Waypoint CLI. See [installation instructions](https://developer.hashicorp.com/waypoint/tutorials/get-started-docker/get-started-install).

#### Waypoint Server

You'll need a Waypoint server. We recommend using [HCP Waypoint](https://cloud.hashicorp.com/products/waypoint)
You'll also need your CLI configured with a [context](https://developer.hashicorp.com/waypoint/commands/context-create)
pointing to this server.

#### Waypoint remote runner

Waypoint remote runners are required to use variables with dynamic defaults. HCP Waypoint will 
walk you through installing a remote runner into your infrastructure. If you don't have
a runner already, you can run `waypoint runner agent` in a separate terminal window. This
runner will have access to docker on your laptop, which is where we'll be deploying.

#### Waypoint Terraform Configsourcer Config

Waypoint needs to know how to talk to Terraform cloud at runtime to source the outputs. 
To accomplish this, run:

```shell
waypoint config source-set -type=terraform-cloud -config=token=<your-tfc-token>
```
#### Customize the waypoint.hcl


Take a look at the waypoint.hcl. In each variable stanza, you'll need to update the
Terraform organization to match the one your chose during the Terraform setup

Example
```hcl
variable "single_string_output" {
  default = dynamic("terraform-cloud", {
    organization = "waypoint_tfc_vars_example" // REPLACE WITH YOUR ORG ID
    workspace    = "waypoint_tfc_vars_example"
    output       = "simple_string"
  })
  type        = string
  sensitive   = false
  description = "Just one tfc output variable with a string type"
}
```

You'll need to commit those changes, and then push to a repository you control. We recommend
forking the waypoint-examples repo and modifying your fork. The changes need to be 
pushed for the remote runner to recognize them.

#### Waypoint Project

Create your Waypoint project, pointed to your git repo. You'll need to update the git
url to point to your fork

```shell
$ waypoint project apply \
  -data-source="git" \
  -git-ref=main \
  -git-url="https://github.com/<YOUR_ORG>/waypoint-examples" \ # <-- YOUR FORK HERE
  -git-path=terraform/variables \
  waypoint_tfc_vars_example
  
✓ Project "waypoint_tfc_vars_example" created
```

## Running the deployment

Run `waypoint up` to build and deploy a docker container. If you're running a runner locally
using `waypoint runner agent` (and you have no other runners), add `-local=false` to force
remote execution on that runner. 

```shell
$ waypoint up -local=false

...

The deploy was successful!
```

## Inspecting the variable usage

The variables were used to configure the docker container. 

Use docker inspect to find the deployed container:

```shell
$ docker ps
CONTAINER ID   IMAGE                                             COMMAND                  CREATED       STATUS                  PORTS                             NAMES
589d62b07137   waypoint.local/waypoint_tfc_vars_example:latest   "/waypoint-entrypoin…"   2 hours ago   Up 2 hours              80/tcp, 0.0.0.0:62584->3000/tcp   waypoint_tfc_vars_example-01GMZXBPN9R187QFGRGNEN288W

```

And then inspect to see the tfc configvars. Only the environment and labels contain tfc config.

```shell
$ docker inspect 589d62b07137 | jq '.[0].Config | with_entries(select([.key] | inside(["Env", "Labels"])))'
{
  "Env": [
    "tfc_output_key1=tfc_output_value1",
    "tfc_output_key2=tfc_output_value2",
    ...
  ],
  "Labels": {
    "list_item": "tfc_output_item_2",
    "simple_string": "tfc_output_string",
    ...
  }
}
```

Notice that the TFC variables have been injected into the docker deployment config!

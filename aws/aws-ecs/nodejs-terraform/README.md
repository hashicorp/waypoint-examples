# Waypoint AWS-ECS Example with a cluster sourced from TFC

|Title|Description|
|---|---|
|Pack|Cloud Native Buildpack|
|Cloud|AWS|
|Language|NodeJS|
|Docs|[AWS-ECS](https://www.waypointproject.io/plugins/aws-ecs)|
|Tutorial|[HashiCorp Learn](https://learn.hashicorp.com/tutorials/waypoint/aws-ecs)|

This example demonstrates the AWS Elastic Container Service `deploy` plugin
which also provides a `build` step for the Elastic Container Registry.

It uses a cluster created with terraform (see the ./terraform directory), and uses the ecs cluster name as an output value in the application.

### Prerequisites

- Create a terraform cloud account and run the terraform in the `./terraform` directory

- Configure the [terraform-cloud configsourcer](https://www.waypointproject.io/plugins/terraform-cloud#source-parameters). Example:

```
wp config source-set -type=terraform-cloud -config=token=$TFC_TOKEN`
```

- Install a [remote runner](https://www.waypointproject.io/commands/runner-install), and configure your project with a [git url](https://www.waypointproject.io/commands/project-apply#git-url). Dynamic config is not allowed to be sourced on local operations.




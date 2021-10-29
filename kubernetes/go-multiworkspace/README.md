# Waypoint Multi-Workspace example (in go)

| Title    | Description                                                                          |
| -------- | ------------------------------------------------------------------------------------ |
| Pack     | Docker                                                                               |
| Cloud    | Kubernetes/AWS                                                                       |
| Language | Go                                                                                   |
| Tutorial | coming soon                                                                          |

This is a complex example showing how workspaces can be used to model dev and prod environments, where dev and prod have different namespaces, different config (sourced from vault), and different load balancers, with only the prod loadbanalcer public.


## Prerequisites

### Waypoint installation

Waypoint will need to be installed in such a way that it can access the dev and prod k8s namespaces. This is most easily accomplished by installing Waypoint with the [helm](https://www.Waypointproject.io/docs/kubernetes/helm-deploy)

### Vault setup

A vault cluster is required. It's api address must be reachable from pods in your dev and prod namespaces. The best way to set this up is by configuring the [vault kubernetes auth method](https://www.vaultproject.io/docs/auth/kubernetes), and the Waypoint vault config sourcer using [kubernetes auth](https://www.Waypointproject.io/plugins/vault#kubernetes_role).

This also presumes that dev and prod exist in vault under a KV secrets engine named `config`, with the path `gomultiapp/{dev,prod}/config.yml`

This has been tested with an [HCP Vault](https://cloud.hashicorp.com/#vault) cluster peered to the AWS VPC that contiains the EKS cluster.

### AWS setup

This project uses the AWS ECR container registry, AWS loadbalancers, and has been tested on EKS. To support gitops workflows, Waypoint runners need push access to ECR - this can be accomplished by adding the AmazonEc2ContainerRegistryFullAccess policy to the eks node group role, but more granuar access is also possible.


## Dev and Prod Environments

In this example, the dev environment is represented by the "default" Waypoint workspace, and prod by the "prod" workspace.

Deploying in dev is as easy as 

```shell-session
$ Waypoint up
```

To interact with the prod environment, add the `-workspace=prod` flag to any Waypoint command. After verifying changes in dev,
they can be deployed to prod with

```shell-session
$ Waypoint up -workspace=prod
```


# Waypoint Multi-Workspace example (in go)

| Title    | Description                                                                          |
| -------- | ------------------------------------------------------------------------------------ |
| Pack     | Docker                                                                               |
| Cloud    | Kubernetes/AWS                                                                       |
| Language | Go                                                                                   |
| Tutorial | coming soon                                                                          |

This is a complex example showing how workspaces can be used to model dev and prod environments, where dev and prod have different namespaces, different config (sourced from vault), and different load balancers, with only the prod load balancer public.


## Prerequisites
### Kubernetes namespaces

You should have namespaces in your k8s cluster named `dev` and `prod`. These names are used in the waypoint.hcl.

### Waypoint installation

Waypoint will need to be installed in such a way that it can access the dev and prod k8s namespaces. This is most easily accomplished by installing Waypoint with the [helm chart](https://www.Waypointproject.io/docs/kubernetes/helm-deploy).

### Vault setup

A Vault cluster is required. Its api address must be reachable from pods in your dev and prod namespaces. The best way to set this up is by configuring the [Vault Kubernetes auth method](https://www.vaultproject.io/docs/auth/kubernetes), and the Waypoint Vault config sourcer using [Kubernetes auth](https://www.Waypointproject.io/plugins/vault#kubernetes_role).

This also presumes that dev and prod exist in Vault under a KV secrets engine named `config`, with the path `gomultiapp/{dev,prod}/config.yml`

This has been tested with an [HCP Vault](https://cloud.hashicorp.com/#vault) cluster peered to the AWS VPC that contains the EKS cluster.

### AWS setup

This project uses the AWS ECR container registry, AWS loadbalancers, and has been tested on EKS. To support gitops workflows, Waypoint runners need push access to ECR - this can be accomplished by adding the `AmazonEc2ContainerRegistryFullAccess` policy to the EKS node group role, but more granular access is also possible.


## Dev and Prod Environments

In this example, the dev environment is represented by the "default" Waypoint workspace, and prod by the "prod" workspace.

To deploy to dev:

```shell-session
$ waypoint up
```

To interact with the prod environment, add the `-workspace=prod` flag to any Waypoint command. After verifying changes in dev,
they can be deployed to prod with:

```shell-session
$ waypoint up -workspace=prod
```


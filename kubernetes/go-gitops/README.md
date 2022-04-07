# Waypoint Go Example

| Title    | Description                                                                          |
| -------- | ------------------------------------------------------------------------------------ |
| Pack     | Cloud Native Buildpack                                                               |
| Cloud    | Local                                                                                |
| Language | Go                                                                                   |
| Docs     | [Docker](https://www.waypointproject.io/plugins/docker)                              |
| Tutorial | [HashiCorp Learn](https://learn.hashicorp.com/tutorials/waypoint/get-started-docker) |

A barebones Go API, which can easily be deployed by Waypoint.

This example assumes you will be deploying the application onto Kubernetes.
It also uses a remote container registry jFrog. You'll need
to change the image value to point at your own registry. And be sure to setup
your local Kubernetes cluster to have credentials to pull the image.

This example also allows users to pull registry information out of Vault. For
default values of a registry username and password, Waypoint can use its
dynamic config sourcer plugin to obtain these values rather than requiring that
they be set on the CLI or UI or checked into Git in a `waypoint.hcl`.

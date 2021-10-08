# Waypoint Kubernetes Ingress Proxy Example using Sidecar

|Title|Description|
|---|---|
|Pack|Cloud Native Buildpack|
|Cloud|Any|
|Language|NodeJS|
|Docs|[Kubernetes](https://www.waypointproject.io/plugins/kubernetes)|
|Tutorial|[HashiCorp Learn](https://learn.hashicorp.com/tutorials/waypoint/get-started-kubernetes)|

Waypoint can deploy to a local Kubernetes server or a cloud-hosted cluster. See the tutorial for details.

## Prerequisites

You must have Vault running and Waypoint configured matching to use the [Vault config sourcer](https://www.waypointproject.io/plugins/vault).

1. Start a simple local Vault cluster with token auth, run `vault server -dev -dev-listen-address=<Vault address>` * This address must be accessible by the pods in your Kubernetes cluster. Omit to default to localhost.
2. Configure the Vault config sourcer on Waypoint by running: `waypoint config source-set -type=vault -config=addr=<Vault address> -config=<Vault token>`.
3. Add the 'nginx.conf' secret to Vault matching 'waypoint.hcl': `cat nginx.conf | VAULT_ADDR=<Vault address> VAULT_TOKEN=<Vault token> vault kv put /secret/apps/sample-app nginx.conf=-`

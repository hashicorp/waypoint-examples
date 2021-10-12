# Waypoint Kubernetes Ingress Proxy Example using Sidecar

|Title|Description|
|---|---|
|Pack|Cloud Native Buildpack|
|Cloud|Any|
|Language|NodeJS|
|Docs|[Kubernetes](https://www.waypointproject.io/plugins/kubernetes)|
|Tutorial|[HashiCorp Learn](https://learn.hashicorp.com/tutorials/waypoint/get-started-kubernetes)|

This example shows ingress to an app being proxied by an Nginx sidecar container. 

## Config

Nginx config is stored in Vault, and is delivered by the CEB to a shared memory volume at container startup, and the Nginx container entrypoint override moves it to `/etc/nginx` before starting Nginx itself.

## Prerequisites

You must have Vault running and Waypoint configured matching to use the [Vault config sourcer](https://www.waypointproject.io/plugins/vault).

1. Start a simple local Vault cluster with token auth, run `vault server -dev -dev-listen-address=<Vault address>` * This address must be accessible by the pods in your Kubernetes cluster.
2. Configure the Vault config sourcer on Waypoint by running: `waypoint config source-set -type=vault -config=addr=<Vault address> -config=token=<Vault token>`.
3. Add the 'nginx.conf' secret to Vault at the same path as inside the `configdynamic` block in 'waypoint.hcl': `cat nginx.conf | VAULT_ADDR=<Vault address> VAULT_TOKEN=<Vault token> vault kv put /secret/apps/sample-app nginx.conf=-`

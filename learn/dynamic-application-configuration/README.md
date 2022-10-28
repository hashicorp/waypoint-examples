# Waypoint Go Example

| Title    | Description                                                                                                                 |
| -------- |-----------------------------------------------------------------------------------------------------------------------------|
| Pack     | Cloud Native Buildpack                                                                                                      |
| Cloud    | Nomad                                                                                                                       |
| Language | Go                                                                                                                          |
| Docs     | [Docker](https://www.waypointproject.io/plugins/docker)                                                                     |
| Tutorial | [HashiCorp Waypoint Use Case](https://developer.hashicorp.com/waypoint/docs/use-cases/dynamic-config-vault-dynamic-secrets) |

A minimal Go HTTP server, which connects to a Postgres database, and informs the
client if it has done so successfully. The Waypoint configuration makes use of 
Waypoint's [dynamic configuration](https://developer.hashicorp.com/waypoint/docs/app-config/dynamic) 
feature. The [HashiCorp Vault config sourcer plugin](https://developer.hashicorp.com/waypoint/plugins/vault)
is used to retrieve a dynamic credential for the Postgres database from a database
secret engine mount in Vault.

## Pre-requisites

### Nomad cluster

You should have a Nomad cluster up and running to which your Waypoint runner can
connect to deploy the Nomad job.

### Vault cluster

A Vault cluster is required, and must be reachable from containers running in your
Nomad cluster. It is also assumed that there is a database secrets engine mount,
with a connection configured for a Postgres database. There should also be a role,
named `readonly`.

### Postgres Database

The Nomad job file, `postgres.nomad.hcl`, in this path is a quick, _development_
environment jobspec to get Postgres up and running. It is not intended for production
use, but can optionally be the database that the server connects to, and from which
Vault sources dynamic credentials.

# {{ .ProjectName }} Overview

This Waypoint project is a microservice written in GoLang. It is a gRPC server,
which uses protocol buffers for its API. This project contains a Dockerfile
used to build this application into a container. The Go binary produced by
building this app is "wrapped" by the [Waypoint Entrypoint](https://developer.hashicorp.com/waypoint/docs/entrypoint).
This provides configuration to the application dynamically at runtime.

## Starter API

This Waypoint project has an RPC, `HelloWorld`, which is an example RPC that
returns back the same message sent in a gRPC request. Below is an example of
how to access the service with a tool `grpcurl`. The server's hostname and port
on which it is listening must be substituted in here.

```shell
$ grpcurl \
  -d "{ \"message\": \"The first and last name in Vault technology.\"}" \
  <SERVER_HOSTNAME>:<SERVER_PORT> \
  {{ .ProjectName }}.v1.{{ .ProjectName }}Service/HelloWorld
```

## Database Connection

This Waypoint project contains a second RPC, `ConnDB`, used to connect to a
Postgres database. The Waypoint Entrypoint, mentioned in the overview, is
configured to provide several environment variables to the application, used
for connecting to the database. These include:

- `DATABASE_HOSTNAME`
- `DATABASE_PORT`
- `DATABASE_USERNAME`
- `DATABASE_PASSWORD`
- `DATABASE_NAME`

## Infrastructure

The application infrastructure created for this Waypoint project is managed in
the Terraform Cloud org {{ .TfcOrgName }}, by the workspace {{ .ProjectName }}.

## Continuous Integration and Deployment

On branches off of `main`, each commit pushed to GitHub will trigger a build,
which will push the app container to a Docker registry. On merges to `main`,
GitHub Actions will trigger a Waypoint deployment to the `dev` environment.

If you have the Waypoint CLI configured, you may also manually trigger a
deployment using this command:

```shell
$ waypoint up -p {{ .ProjectName }} -a {{ .ProjectName }} -w dev -remote-source=ref=<GIT_COMMIT_ID>
```

## Telemetry

To view app metrics, log into DataDog and search for a dashboard with the name
"{{ .ProjectName }}". This dashboard will contain metrics for CPU, memory,
network, and disk for the application container.

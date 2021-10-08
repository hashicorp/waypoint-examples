# Waypoint Kubernetes Sidecar Local Proxy Example

|Title|Description|
|---|---|
|Pack|Cloud Native Buildpack|
|Cloud|Any|
|Language|NodeJS|
|Docs|[Kubernetes](https://www.waypointproject.io/plugins/kubernetes)|
|Tutorial|[HashiCorp Learn](https://learn.hashicorp.com/tutorials/waypoint/get-started-kubernetes)|

This is an example of a Telegraf sidecar that listens for StatsD metrics on port 8125, tags them, and forwards them to InfluxDB.
Waypoint can deploy to a local Kubernetes server or a cloud-hosted cluster. See the tutorial for details.

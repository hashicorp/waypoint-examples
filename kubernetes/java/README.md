# Java Getting Started

|Title|Description|
|---|---|
|Pack|GCR|
|Cloud|Multiple|
|Language|Java|
|Docs|[Kubernetes](https://www.waypointproject.io/plugins/kubernetes)|
|Tutorial|[HashiCorp Learn](https://learn.hashicorp.com/tutorials/waypoint/get-started-docker)|

This is an example Java Spring application that can be deployed with Waypoint.

Waypoint defaults to using Heroku buildpacks if you do not specify a [builder variable](https://waypointproject.io/plugins/pack#builder) in the `waypoint.hcl` configuration section for `pack` within the `build` section. This example uses Heroku buildpacks by default.

# Deploying the example application.

1. Install a Waypoint Server up and ensure `waypoint context verify` is successful.
1. `waypoint init`
1. `waypoint up`
1. Visit a URL provided in the `waypoint` output.

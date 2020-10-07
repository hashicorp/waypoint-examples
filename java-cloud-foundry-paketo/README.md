# Cloud Foundry Java Spring Getting Started
Waypoint defaults to using Heroku buildpacks if you do not specify a [builder variable](https://waypointproject.io/plugins/pack#builder) in the  `waypoint.hcl` configuration section for `pack` within the `build` section.  This example uses [Cloud Foundry Paketo Buildpacks](https://paketo.io/docs/) with Waypoint. This example defaults Cloud Foundry.

# Deploying the example application.

1. Install a Waypoint Server up and ensure `waypoint context verify` is successful.
1. `waypoint init`
1. `waypoint up`
1. Visit a URL provided in the `waypoint` output.

## Configuring Waypoint for Cloud Foundry Paketo Buildpacks.

There are two primary `waypoint.hcl` adjustments to enable Cloud Foundry Paketo Buildpacks.

1. The `builder` variable of the `pack` build plugin should specify the a Paketo buildpacks builder image such as `paketobuildpacks/builder:base`. If no builder image is specified, Waypoint uses the Heroku builder image `heroku/buildpacks:18` by default.
1. The `service_port` variable of the deploy plugin explicity specifies port `8080` which is commonly used by Paketo buildpacks. The default Waypoint `service_port` is `3000`.

Here is a full `waypoint.hcl` example that works with Paketo buildpacks.

```
project = "example-java"

app "example-java" {
    build {
        use "pack" {
            builder="paketobuildpacks/builder:base"
        }
    }
    deploy {
        use "docker" {
            service_port=8080
        }
    }
}
```

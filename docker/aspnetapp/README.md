# Waypoint ASP.NET Example

|Title|Description|
|---|---|
|Pack|Cloud Native Buildpack|
|Cloud|Local|
|Language|ASP.NET|
|Docs|[Docker](https://www.waypointproject.io/plugins/docker)|
|Tutorial|[HashiCorp Learn](https://learn.hashicorp.com/tutorials/waypoint/get-started-docker)|

A barebones ASP.NET app (via [Microsoft docs](https://dotnet.microsoft.com/learn/aspnet/hello-world-tutorial/intro)) which can easily be deployed by Waypoint.

Under `Properties/launchSettings.json`, you must set `"applicationUrl": "http://+:80"` so it is accessible outside the container.

The buildpack defaults to port `8080`, so you must set `service_port = 8080` in the `deploy` stanza (as shown in `waypoint.hcl`).
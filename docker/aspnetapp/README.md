# Waypoint ASP.NET Example

|Title|Description|
|---|---|
|Pack|Docker|
|Cloud|Local|
|Language|ASP.NET|
|Docs|[Docker](https://www.waypointproject.io/plugins/docker)|
|Tutorial|[HashiCorp Learn](https://learn.hashicorp.com/tutorials/waypoint/get-started-docker)|

A barebones ASP.NET app (via [Microsoft docs](https://dotnet.microsoft.com/learn/aspnet/hello-world-tutorial/intro)) which can easily be deployed by Waypoint.

Under `Properties/launchSettings.json`, you must set `"applicationUrl": "http://+:80"` so it is accessible outside the container.

Waypoint defaults to port 3000, so you must set `service_port = 80` in the `deploy` stanza (as shown in `waypoint.hcl`).
# php-getting-started

A barebones Laravel 8 app, which can easily be deployed by Waypoint.
This repository provides a .env file to make it easy to deploy the example, 
however these environment variables should be managed using `waypoint config`.
Laravel `TrustProxies` has been set to `*` as an example to allow Laravel to 
generate the correct SSL asset URL.

# Waypoint Node.js GraphQL Example

|Title|Description|
|---|---|
|Pack|Docker|
|Cloud|AWS|
|Language|NodeJS|
|Docs|[AWS Lambda](https://www.waypointproject.io/plugins/aws-lambda)|
|Tutorial| N/A |

This example demonstrates the AWS Lambda `deploy` plugin.

It uses [`apollo-server-lambda`][apollo-server-lambda] to handle the mapping of various AWS event objects (API Gateway, ALB, Lambda@Edge) to lambda.

To deploy, run `waypoint up`. It will take a few minutes for a brand new load balancer to be fully provisioned.

To destroy, run `waypoint destroy -auto-approve`

[apollo-server-lambda]: https://github.com/apollographql/apollo-server/tree/main/packages/apollo-server-lambda
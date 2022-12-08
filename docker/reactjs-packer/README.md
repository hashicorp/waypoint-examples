# Waypoint React.js Example

|Title|Description|
|---|---|
|Pack|Cloud Native Buildpack|
|Cloud|Local|
|Language|JavaScript|
|Docs|[Docker](https://www.waypointproject.io/plugins/docker)|
|Tutorial|[HashiCorp Learn](https://learn.hashicorp.com/tutorials/waypoint/get-started-docker)|

This example demonstrates the usage of the Packer config sourcer plugin with a 
ReactJS application. 

To use the `nginx:stable-alpine` Docker image as the base image for the ReactJS
application, firstly the Packer build must be run with the command below. This 
will pull the `nginx:stable-alpine` image from DockerHub, and push it to a local
registry, hosted at `localhost:5000`. Additionally, the configuration will push
the image metadata to a bucket in the HCP Packer registry, named `nginx`.

```shell
$ packer build nginx.pkr.hcl
```

To use the Packer plugin, the configuration for the Packer plugin must be set
with the command below. An HCP client ID and secret, organization ID and project
ID must be set.

```shell
$ waypoint config source-set -type=packer -config=client_id=sunset -config=client_secret=sarsaparilla -config=organization_id=nuka-cola -config=project_id=quantum
```

With that set, the dynamic input variable for the base image will retrieve the
image ID from your HCP Packer registry. The image ID returned will be the one
whose cloud provider and region match the one in the configuration. In this
example, this is `docker` for both, as the Docker plugin for Packer will set
this metadata, though other cloud providers may do thing differently.

```hcl
variable "image" {
  default = dynamic("packer", {
    bucket  = "nginx"
    channel = "base"
    region  = "docker"
    cloud   = "docker"
  })
  type        = string
  description = "The name of the base image to use for building app Docker images."
}
```

This dynamic input variable is used during the build portion of the Waypoint
app lifecycle.

```hcl
  build {
    use "docker" {
      dockerfile = templatefile("${path.app}/Dockerfile", {
        base_image = var.image
      })
    }
  }
```

In the Dockerfile, this value is templated into the base image.

```Dockerfile
FROM node:13.12.0-alpine as build
WORKDIR /app
ENV PATH /app/node_modules/.bin:$PATH
COPY package.json ./
COPY package-lock.json ./
RUN npm ci --silent
RUN npm install react-scripts@3.4.1 -g --silent
COPY . ./
RUN npm run build

# The image ID is templated here
FROM ${base_image}
COPY nginx/default.conf /etc/nginx/conf.d/
COPY --from=build /app/build /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

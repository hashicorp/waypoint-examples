# Waypoint Go Example with Docker and Docker Pull

| Title    | Description                                                                              |
| -------- | ---------------------------------------------------------------------------------------- |
| Pack     | Docker, Docker Pull                                                                      |
| Cloud    | Kubernetes                                                                               |
| Language | Go                                                                                       |
| Docs     | [Kubernetes](https://www.waypointproject.io/plugins/kubernetes)                          |

A barebones Go API, with a quick minimal docker build, deployed to Kubernetes.

This example demonstrates using the `docker-pull` plugin, to pull the image
build in a non-production build/release, and use it for a production deployment. 

The included `waypoint.hcl` file contains several variables with defaults, but
users will need to supply their own registry credentials. It is not recommended
to include credentials in the `waypoint.hcl` file itself, instead an easy way to
try this example would be to create a local `wpvars` files and use them when
running `waypoint` commands. 

### Example: Creating a development build

Create the initial development build using the `ex.wpvars` file like so:

```
# dev.wpvars 
// push to the dev registry
push_image="dev-registry-url/example-go-pull"
push_registry_username="developer"
push_registry_password="some password"
```

Then execute a `waypoint build`, referencing the file:

```
$ waypoint build -var-file=dev.wpvars

» Building go-k8s...
  Performing operation on "kubernetes" with runner profile "01GGACDWSQZ1BR3TNR8EW0KY1A"

» Cloning data from Git
  URL: https://github.com/hashicorp/waypoint-examples.git
  Ref: go-workspace-pull

» Downloading from Git
  Git Commit: a59c6a6a518bc22259db35cc0ba02b1dd56d4483
   Timestamp: 2022-10-28 17:19:00 +0000 UTC
     Message: more updates

✓ Running build v17
✓ Building Docker image with kaniko...
✓ Testing registry and uploading entrypoint layer
✓ Executing kaniko...
 │ INFO[0012] Executing 0 build triggers
 │ INFO[0012] Unpacking rootfs as cmd COPY --from=builder /tmp/go-k8s /go-k8s requi
 │ res it.
 │ INFO[0012] COPY --from=builder /tmp/go-k8s /go-k8s
 │ INFO[0012] Taking snapshot of files...
 │ INFO[0012] COPY --from=builder /app-src/static /static
 │ INFO[0012] Taking snapshot of files...
 │ INFO[0012] CMD [ "/go-k8s" ]
 │ INFO[0012] Pushing image to localhost:37809/catsby/example-go-pull:dev
 │ INFO[0014] Pushed image to 1 destinations
✓ Image pushed to 'catsby/example-go-pull:dev'
✓ Running push build v16

Created artifact v16

» Variables used:
         VARIABLE        |                     VALUE                     |   TYPE    | SOURCE
-------------------------+-----------------------------------------------+-----------+----------
  pull_registry_password | b1f991bfcaf3ab4dc9383bae461e2b9ce331103bb55a0 | sensitive | default
                         | 63d66c378a40980c817                           |           |
  pull_registry_username | 890e8f907513987332a9679089def709997ac359a11e8 | sensitive | default
                         | e378c0810e9eac12e16                           |           |
  pull_tag               | dev                                           | string    | default
  push_registry_password | 122bc444b708853582dafe3cda069461b2a2c6ebce9a9 | sensitive | file
                         | d38aee531a98d6d3d03                           |           |
  push_registry_username | 890e8f907513987332a9679089def709997ac359a11e8 | sensitive | file
                         | e378c0810e9eac12e16                           |           |
  push_tag               | dev                                           | string    | default
  port                   |                                          3000 | int       | default
  pull_image             | catsby/example-go-pull                        | string    | default
  push_image             | catsby/example-go-pull                        | string    | file
```

This will create the first docker image and push it up to the registry defined in the `dev.wpvars` file.

Specifically note that:

 - The output from Kaniko demonstrates actually building the container image
 - the `SOURCE` for the `push_` variables are read from file
 - the `SOURCE` for the `pull_` variables use the defaults because they were not overriden in the `dev.wpvars` file

### Example: Creating a production build

Users can then use the dev image with the `docker-pull` plugin by using another wpvars file which overrides the `pull_` variables:

```
# prod.wpvars 
// pull from the dev registry
pull_image="dev-registry-url/example-go-pull"
pull_registry_username="developer"
pull_registry_password="some password"

// push to the prod registry
push_image="prov-registry-url/example-go-pull"
push_registry_username="releaser"
push_registry_password="some password"
```

Run a production build with `waypoint build`, referencing the prod wpvars file:

```
$ waypoint build -workspace=production -var-file=prod.wpvars

» Building go-k8s...
  Performing operation on "kubernetes" with runner profile "01GGACDWSQZ1BR3TNR8EW0KY1A"

» Cloning data from Git
  URL: https://github.com/hashicorp/waypoint-examples.git
  Ref: go-workspace-pull

» Downloading from Git
  Git Commit: a59c6a6a518bc22259db35cc0ba02b1dd56d4483
   Timestamp: 2022-10-28 17:19:00 +0000 UTC
     Message: more updates

✓ Running build v18
✓ Injecting entrypoint...
⠋ Executing Kaniko...
 │ INFO[0000] Retrieving image manifest localhost:33775/catsby/example-go-pull:dev
 │ INFO[0000] Retrieving image localhost:33775/catsby/example-go-pull:dev from regi
 │ stry localhost:33775
 │ INFO[0000] Built cross stage deps: map[]
 │ INFO[0000] Retrieving image manifest localhost:33775/catsby/example-go-pull:dev
 │ INFO[0000] Returning cached image manifest
 │ INFO[0000] Executing 0 build triggers
 │ INFO[0000] Skipping unpacking as no commands require it.
 │ INFO[0000] Pushing image to localhost:45983/catsby/example-go-pull:latest
 │ INFO[0001] Pushed image to 1 destinations
✓ Image pull completed.
✓ Running push build v17

Created artifact v17

» Variables used:
         VARIABLE        |                     VALUE                     |   TYPE    | SOURCE
-------------------------+-----------------------------------------------+-----------+----------
  pull_registry_password | 122bc444b708853582dafe3cda069461b2a2c6ebce9a9 | sensitive | file
                         | d38aee531a98d6d3d03                           |           |
  pull_tag               | dev                                           | string    | default
  push_image             | catsby/example-go-pull                        | string    | file
  push_registry_username | 890e8f907513987332a9679089def709997ac359a11e8 | sensitive | file
                         | e378c0810e9eac12e16                           |           |
  push_tag               | latest                                        | string    | default
  port                   |                                          3030 | int       | default
  pull_image             | catsby/example-go-pull                        | string    | file
  pull_registry_username | 890e8f907513987332a9679089def709997ac359a11e8 | sensitive | file
                         | e378c0810e9eac12e16                           |           |
  push_registry_password | 122bc444b708853582dafe3cda069461b2a2c6ebce9a9 | sensitive | file
                         | d38aee531a98d6d3d03                           |           |
```

That command will pull the image tagged as `dev` from the registry used in the first `build` operation 
and push it to the prod registry with the `latest` tag. 

Specifically note that:

 - The output from Kaniko demonstrates simply pulling the image 
 - the `SOURCE` for the `push_` and `pull_` variables are read from file
 - In `prod.wpvars` the `pull_` values should match the `push_` values from `dev.wpvars`
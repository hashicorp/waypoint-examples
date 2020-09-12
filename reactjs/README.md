# Getting Started with Waypoint and ReactJS

## What will we accomplish?

In this getting started guide we will go through using waypoint to deploy a ReactJS application on Docker for Destkop. We will demonstrate leveraging both the `pack` builder to automatically detect the type of user code being built and deploy it, as well as demonstrate using the `docker` builder with a Dockerfile.

## Requirements

This walkthrough assumes the following...

- You have obtained the `waypoint` binary
- You have access to the waypoint server image in the GitHub docker image repository
- You have installed [Docker for Desktop](https://www.docker.com/products/docker-desktop)

## First Steps

### Installing the Waypoint server

We will start by installing the Waypoint server on Docker for Desktop. This installation is done by executing the following command locally on your workstation -

```bash
waypoint install --platfomr=docker
```

In a few moments you should receive a message that the configuration was successful. We're now ready to get started with deploying the application

### "waypoint init" - Configuring your repository

Assuming you are in the directory for this project, we can leverage the `waypoint.hcl` file contained in this sample directory to get started. In projects where no `waypoint.hcl` file exists, this can be created by executing the `waypoint init` command which will generate a basic `waypoint.hcl` file that you can customize. In the case of the example already in this directory, it is configured with sane defaults.

With the file in place, execute the following command to initialize your project and the application

```bash
waypoint init
```

### "waypoint up" - Deploying the application

This application is configured to use Cloud Native Buildpacks to detect the type of application running and launch it within Docker. This configuration means that the user doesn't need to build a Dockerfile manually, but also accepts the default configurations that the Cloud Native Buildpack leverages. It also uses the local Docker instance to build and store the image. For advanced use cases, see the `registry` stanza which allows you to automatically push your built artifact to a registry. We can deploy our application onto docker with the following command:

```bash
waypoint up
```

You should be able to observe waypoint run through the build and deploy process, and ultimately return you URL from Horizon. The response should look something like the below...

```
The deploy was successful! A Waypoint deployment URL is shown below. This
can be used internally to check your deployment and is not meant for external
traffic. You can manage this hostname using "waypoint hostname."

           URL: https://instantly-worthy-shrew.alpha.waypoint.run
Deployment URL: https://instantly-worthy-shrew--01EJ0F2VYWTNTYJ6FNFNTY44G9.alpha.waypoint.run
```

### "waypoint up" part 2 - Editing your application and iterating

One of the most powerful parts of Waypoint is the ability to iterate on deployments. Lets edit our application and show off how Waypoint can manage the lifecycle of a new deployment.

Using your favorite IDE, edit the following file `src/App.js`. We've included a new image in this directory for your that we'll replace the default ReactJS image with.

- On line 2 of the code, replace `./logo.svg` with `./hashi.png` (or another image if you want to use one, just place it in the public directory).
- On line 11 - Edit this line to include a catchy phrase. I prefer a quote from your favorite Marvel Cinematic Universe movie, but hey, live your dream. This is about you as the application developer!

Save your file, and re-run the `waypoint up` command

Upon completion, you'll note that you're provided the same URL as above. The waypoint server has handled automatically swithching the URL to use the most recent version of your deployment.

### "waypoint up" part 3 - Pivoting to Docker Builds

In Waypoint we have 2 builder types, the `pack` builder and the `docker` builder. For users who already have a Dockerfile configured to run their application, the Docker builder provides some great flexibility.

In this sample directory we've included 2 files, a default `Dockerfile` and an `nginx/default.conf` that contains the necessary information for Nginx hosting our application. If you inspect these files, you'll note that they are both set to run our application on port 80, which is different than the default of port 3000.

Access the `waypoint.hcl` file in your IDE of choice, and update it with the following `build` and `deploy` configuration to switch the builder to docker, and the containers expected listening port to 80

```hcl
build {
      use "docker" {}
    }

deploy {
      use "docker" {
          container_port=80
      }
    }
```

Save, make any application changes you would like (if you want to change your quote, image, etc...) and execute our `waypoint up` again.

You'll note the build process looks a bit different this time as it's building your docker image using the dockerfile. Upon completion you'll once again receive the same Horizon URL, which will now direct you to your application hosted within Nginx instead.

### OPTIONAL - "waypoint up" part 4 - Pivoting to Kubernetes

This same configuration can be used to deploy the application to a Kubernetes cluster by deploying a new waypoint server onto Kubernetes and changing our `waypoint.hcl` file to reference that instead. This guide assumes you have a Kubernetes cluster configured either locally using a number of tools (Docker for Desktop, Shipyard, Kind) or on a cloud endpoint and have a valid kubeconfig file applied, as well as have a Docker registry to put your image into. For local Kubernetes clusters, such as the one running in Docker for Desktop, you can use the `local` configuration, which will not push the image to a remote repository.

To begin, we will run the install command (a second time), which by default attempts to install to a Kubernetes cluster.

```
waypoint install
```

Upon completion you'll receive a message indicating that the server is ready to use, and the address should match your Kubernetes cluster. Our `waypoint context` is automatically switched to use that server instead of our local instance (if we attempt to use our local Docker instance, workloads that deploy onto our Kubernetes cluster are going to attempt to communicate with our waypoint server via the Docker DNS name, which is going to be unreachable unless you're Kubernetes cluster and Docker are running on the same machine). If you ever want to switch back to your local docker context, you can use a combination of `waypoint context list` and `waypoint context use <name>` to switch back. Also play with `waypoint context rename <oldname> <newname>` to create friendlier names!

We will now modify our `waypoint.hcl` file to use Kubernetes instead. Update the `waypoint.hcl` file with the following `build` and `deploy` steps, and add a new section called `release`.

```hcl
app "reactjs" {
    build {
      use "docker" {}
      registry {
        use "docker" {
          image = "waypoint.local/sample/reactjs"
          tag = "latest"
          local = true
        }
       }
    }

   deploy {
      use "kubernetes" {
          probe_path = "/"
          container_port = 80
      }
    }

    release {
        use "kubernetes" {
            load_balancer = true
            port = 80
        }
    }
}
```

With this configuration in place, execute our up command again...

```bash
waypoint up
```

You will receive a new URL for connectivity, since we are using a new server instance. If you execute a `kubectl get deployments` against your Kubernetes cluster you will see the entry for your application listed. If you execute a `kubectl get services` you should see all the services listed in the default namespace, which includes your application.

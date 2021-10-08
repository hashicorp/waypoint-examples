project = "example-nodejs-sidecar"
app "example-nodejs-ingress-sidecar" {
 labels = {
   "service" = "example-nodejs-sidecar",
   "env"   = "dev"
 }
 build {
  use "pack" {}
   registry {
   use "docker" {
    image = "example-nodejs-sidecar"
     tag  = "1"
     local = true
   }
  }
 }
 config {
   file = {
    "/shared-config/nginx.conf" = configdynamic("vault", {
    path = "secret/data/apps/sample-app"
     key = "data/nginx.conf"
    })
   }
 }
 deploy {
   use "kubernetes" {
   namespace = "default"
    probe_path = "/"
    scratch_path = ["/shared-config"]
   port {
    name = "app-port"
     port = 8080
    }
   pod {
    sidecar {
      name = "nginx"
      image = "nginx:1.21.1"
      port {
       name = "http"
       port = 80
      }
      command = ["/bin/sh"]
      args = ["-c", "until [ -f /shared-config/nginx.conf ]; do sleep 1; echo 'waiting for waypoint app container to inject config at /shared-config/nginx.conf...'; done; cp /shared-config/nginx.conf /etc/nginx/nginx.conf; nginx -g 'daemon off;'"]
     }
   }
  }
 }
 release {
  use "kubernetes" {
     port = 443
  }
 }
}
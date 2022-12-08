build {
  hcp_packer_registry {
    bucket_name = "nginx"
    description = "Nginx image."
  }

  sources = [
    "source.docker.nginx"
  ]

  post-processors {
    // The two postprocessors here will push the image to a local registry
    post-processor "docker-tag" {
      repository = "localhost:5000/nginx"
      tags       = [ "stable-alpine" ]    
    }
    
    post-processor "docker-push" {
      login = false
    }
  }
}

source "docker" "nginx" {
  image = "nginx:stable-alpine"
  commit = true
}

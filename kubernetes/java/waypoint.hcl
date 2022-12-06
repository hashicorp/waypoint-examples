project = "kubernetes-java"

pipeline "nested" {
 step "build" {
    use "build" {}
  }
 step "deploy" {
   use "deploy" {}
 }
}

app "kubernetes-java-app" {
  
  build {
    use "pack" {}
    registry {
      use "docker" {
        image = "registry.services.demophoon.com/xxtest"
        tag   = "latest"
      }  
    }
  }

  deploy {
    use "kubernetes" {
      namespace = "default"
      probe_path = "/"
      service_port = 8080
    }
  }

  release {
    use "kubernetes" {
      node_port = 32000
    }
  }
}

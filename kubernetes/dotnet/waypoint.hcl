project = "example-dotnet"

app "example-dotnet" {
  labels = {
      "service" = "example-dotnet",
      "env" = "dev"
  }

  build {
    use "docker" {}
    registry {
        use "docker" {
          image = "c1.k8s.cluster:5000/waypoint/example-dotnet"
          tag = "v20.10.22"
          local = false
        }
    }
 }

  deploy { 
    use "kubernetes" {
    probe_path = "/"
    }
  }

  release {
    use "kubernetes" {
    }
  }
}

project = "example-java"

app "example-java" {
  labels = {
    "service" = "example-java",
    "env" = "dev"
  }

  build {
    use "pack" {}
    }

  deploy { 
    use "docker" {}
  }
  
}

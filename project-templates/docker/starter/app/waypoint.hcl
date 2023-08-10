project = "ctsanotherone"

# runner {
#   enabled = true

#   data_source "git" {
#     url  = "https://github.com/hashicorp/waypoint-examples.git"
#     path = "docker/starter/app"
#     ref = "project-cts"
#   }
# }

app "ctsanotherone" {
  build {
    use "docker" {}
    registry {
      use "docker" {
        image    = "ttl.sh/ctsanotherone"
        tag      = "60m"
        local    = false
      }
    }
  }

  deploy {
    use "docker" {
    }
  }
}

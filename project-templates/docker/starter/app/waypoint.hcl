project = "ctsanotherone"

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

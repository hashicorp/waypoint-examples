project = "ctsanotherone"

app "ctsanotherone" {
  build {
    use "docker" {
    }
  }

  deploy {
    use "docker" {
    }
  }
}
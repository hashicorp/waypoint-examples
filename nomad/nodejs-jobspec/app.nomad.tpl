job "web" {
  datacenters = ["dc1"]
  group "app" {
    task "app" {
      driver = "docker"
      config {
        image = "${artifact.image}:${artifact.tag}"

        // For local Nomad, you prob don't need this on a real deploy
        network_mode = "host"
      }
      env {
        %{ for k,v in entrypoint.env ~}
        ${k} = "${v}"
        %{ endfor ~}

        // For URL service
        PORT = "3000"
      }
    }
  }
}

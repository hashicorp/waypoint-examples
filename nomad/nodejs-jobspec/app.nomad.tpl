job "web" {
  datacenters = ["dc1"]
  group "app" {
    update {
      max_parallel = 1
      canary       = 1
      auto_revert  = true
      auto_promote = false
      health_check = "task_states"
    }

    task "app" {
      driver = "docker"
      config {
        image = "${artifact.image}:${artifact.tag}"
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

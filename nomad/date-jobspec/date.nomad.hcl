job "date-system" {
  datacenters = ["dc1"]

  type = "system"

  periodic {
    // Launch every 20 seconds
    cron = "*/20 * * * * * *"

    // Do not allow overlapping runs.
    prohibit_overlap = true
  }

  group "date-group" {
    count = 1
    network {
      port "date" {}
    }

    restart {
      interval = "20s"
      attempts = 2
      delay    = "5s"
      mode     = "delay"
    }

    task "date-task" {
      driver = "docker"

      service {
        name = "date-batch-job"
        tags = ["date"]
        port = "date"
	provider = "nomad"

        check {
          name     = "alive"
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }

      config {
        image = "${artifact.image}:${artifact.tag}"
	command = "date"
      }

      resources {
        cpu = 100 # Mhz
        memory = 128 # MB
        }
      }
    }
  }

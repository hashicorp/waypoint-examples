project = "example-nodejs-sidecar"
app "example-nodejs-metrics-sidecar" {
  labels = {
    "service" = "example-nodejs-sc",
    "env"   = "dev"
  }
  build {
    use "pack" {}
    registry {
      use "docker" {
        image = "example-nodejs-sidecar"
        tag  = "1"
        local = true
      }
    }
  }

  deploy {
    use "kubernetes" {
      namespace = "default"
      probe_path = "/"
      scratch_path = ["/shared-config"]
      port {
        name = "app-port"
        port = 8080
      }
      pod {
        sidecar {
          name = "telegraf"
          image = "telegraf:1.19.3"
          port {
            name = "health"
            port = 8127
          }
          port {
            name = "statsd-tcp"
            port = 8126
          }
          port {
            name = "statsd-udp"
            port = 8125
          }
          probe_path = "/health"
          command = ["/bin/sh"]
          args = ["-c", "echo $TELEGRAF_CONF | base64 --decode > /opt/telegraf.conf; telegraf --config /opt/telegraf.conf"]
          static_environment = {
            "TELEGRAF_CONF": filebase64("${path.app}/telegraf.conf")
          }
        }
      }
    }
  }
  release {
    use "kubernetes" {
      port = 443
    }
  }
}

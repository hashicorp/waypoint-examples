project = "my-project"

pipeline "full-up" {
  step "my-build" {
    use "build" {}
  }

  step "my-deploy" {
    use "deploy" {}
  }
  #
  #  step "my-release" {
  #    use "release" { }
  #  }
}

app "my-app" {
  build {
    use "docker" {}
    registry {
      use "docker" {
        image = "registry.services.demophoon.com/xxtest"
        tag   = "latest"
        local = false
      }
    }
  }
  deploy {
    use "kubernetes" {
      namespace  = "default"
      probe_path = "/"
      #      scratch_path = ["/shared-config"]
      #      service_port = 8080
      #      pod {
      #        sidecar {
      #          image = "telegraf:1.19.3"
      #          container {
      #            name = "telegraf"
      #            port {
      #              name = "health"
      #              port = 8127
      #            }
      #            port {
      #              name = "statsd-tcp"
      #              port = 8126
      #            }
      #            port {
      #              name = "statsd-udp"
      #              port = 8125
      #            }
      #            probe_path = "/health"
      #            command    = ["/bin/sh"]
      #            args       = ["-c", "echo $TELEGRAF_CONF | base64 --decode > /opt/telegraf.conf; telegraf --config /opt/telegraf.conf"]
      #            static_environment = {
      #              "TELEGRAF_CONF" : filebase64("${path.app}/telegraf.conf")
      #            }
      #          }
      #        }
      #      }
    }
  }
  #  release { ... }
}

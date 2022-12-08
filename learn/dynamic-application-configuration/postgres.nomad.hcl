job "postgres" {
  region      = "global"
  datacenters = ["dc1"]

  group "postgres" {
    network {
      port "postgres" {
        static = 5432
        to     = 5432
      }
    }

    task "postgres" {
      driver = "docker"
      config {
        image = "postgres"
        ports = ["postgres"]
      }

      env {
        POSTGRES_USER     = "postgres"
        POSTGRES_PASSWORD = "root"
      }
    } // end of task
  }   // end of group
}     // end of job
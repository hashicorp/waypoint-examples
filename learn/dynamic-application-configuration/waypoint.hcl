project = "learn-dynamic-go"

app "dynamic-go" {
  labels = {
    "service" = "dynamic-go",
  }

  config {
    env = {
      "USERNAME" = dynamic("vault", {
        path = "database/creds/readonly"
        key  = "username"
      })
      "PASSWORD" = dynamic("vault", {
        path = "database/creds/readonly"
        key  = "password"
      })

      HOST   = var.postgres_ip
      PORT   = var.postgres_port
      DBNAME = var.postgres_dbname
    }
  }

  build {
    use "pack" {}
    registry {
      use "docker" {
        image = var.image_name
        tag   = var.image_tag
        auth {
          username = var.registry_username
          password = var.registry_password
        }
      }
    }
  }

  deploy {
    use "nomad" {
      service_port = 80
    }
  }
}

variable "postgres_ip" {
  type = string
}

variable "postgres_port" {
  type = number
}

variable "postgres_dbname" {
  type    = string
  default = "postgres"
}

variable "image_name" {
  type = string
}

variable "image_tag" {
  type = string
}

variable "registry_username" {
  type      = string
  sensitive = true
}

variable "registry_password" {
  type      = string
  sensitive = true
}

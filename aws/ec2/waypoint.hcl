project = "aws-ec2-nginx-ami"

app "ec2-nginx" {
  labels = {
    "service" = "ec2-nginx"
    "env"     = "dev"
  }

  build {
    use "aws-ami" {
      filters = {
        // See https://bitnami.com/stack/nginx/cloud/aws/amis
        "image-id" = ["ami-0562fde33e9671bf4"]
      }

      region = "us-west-2"
    }
  }

  deploy {
    use "aws-ec2" {
      region        = "us-west-2"
      instance_type = "t3a.nano"
      service_port  = 80
    }
  }

  release {
    use "aws-alb" {
      port = 80
    }
  }
}

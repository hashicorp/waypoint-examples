project = "example-nodejs"

app "example-nodejs" {
  build {
   use "aws-ecr-pull" {
     region     = var.region
     repository = "example-nodejs"
     tag        = var.tag
   }
  }

  deploy {
    use "aws-lambda" {
      region = var.region
      memory = 512
    }
  }

  release {
    use "lambda-function-url" {

    }
  }
}

variable "region" {
  type = string
  default = "us-east-1"
}

variable "tag" {
  type = string
  default = "1"
}

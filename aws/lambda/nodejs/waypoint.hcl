project = "aws-lambda-nodejs"

app "lambda-nodejs-function" {
  build {
   use "aws-ecr-pull" {
     region     = var.region
     repository = "lambda-nodejs"
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

/*

terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5"
    }
  }

  backend "remote" {
    hostname = "app.terraform.io"
    organization = "Takeda"

    workspaces {
      name = "value"
    }
  }
}

*/
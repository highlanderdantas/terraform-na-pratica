provider "aws" {
  region = "${var.region}"
}

terraform {
  backend "s3" {
    bucket         = "curso-aws-terraform-492427955574-sa-east-1-remote-state"
    key            = "terraform.tfstate"
    region         = "sa-east-1"
    dynamodb_table = "curso-aws-terraform-492427955574-sa-east-1-remote-state"
  }
}

locals {
  env = "${terraform.workspace}"
}

resource "aws_instance" "web" {
  ami           = "${lookup(var.ami, local.env)}"
  instance_type = "${lookup(var.type, local.env)}"

  tags = {
    Name         = "Minha máquina web ${local.env}"
    Env          = "${local.env}"
    Project_Name = "Curso Aws com terraform"
  }
}

variable "region" {
  default = "sa-east-1"
}

variable "ami" {
  type = "map"

  default = {
    "dev"  = "ami-0669a96e355eac82f"
    "prod" = "ami-05145e0b28ad8e0b2"
  }
}

variable "type" {
  type = "map"

  default = {
    "dev"  = "t2.micro"
    "prod" = "t2.medium"
  }
}

variable "region" {
  default = "sa-east-1"
}

variable "ami" {
  default = "ami-0669a96e355eac82f"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "env" {
  default = "dev"
}

variable "key_pair_name" {
  default = "highdantas-dev"
}

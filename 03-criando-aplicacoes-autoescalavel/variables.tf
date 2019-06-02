variable "region" {
  default = "us-east-1"
}

variable "vpc_cdir" {
  default = "192.168.0.0/16"
}

variable "public_a_cdir" {
  default = "192.168.1.0/24"
}

variable "public_b_cdir" {
  default = "192.168.2.0/24"
}

variable "private_a_cdir" {
  default = "192.168.6.0/23"
}

variable "private_b_cdir" {
  default = "192.168.4.0/23"
}

variable "ami" {
  default = "ami-0756fbca465a59a30"
}

variable "instance_type" {
  default = "t2.micro"
}

variable "key_pair" {
  default = "high"
}

variable "enabled_metrics" {
  description = "A list of metrics to collect. The allowed values are GroupMinSize, GroupMaxSize, GroupDesiredCapacity, GroupInServiceInstances, GroupPendingInstances, GroupStandbyInstances, GroupTerminatingInstances, GroupTotalInstances"
  type        = "list"

  default = [
    "GroupMinSize",
    "GroupMaxSize",
    "GroupDesiredCapacity",
    "GroupInServiceInstances",
    "GroupPendingInstances",
    "GroupStandbyInstances",
    "GroupTerminatingInstances",
    "GroupTotalInstances",
  ]
}

provider "aws" {
  region = "${var.region}"
}

locals {
  conn_type = "ssh"
  conn_user = "ec2-user"

  # conn_key     = "${tls_private_key.pkey.private_key_pem}"

  conn_key = "${file("~/Downloads/high.pem")}"
}

resource "aws_instance" "web" {
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name      = "high"

  tags = {
    Name = "Teste"
  }

  provisioner "file" {
    source      = "2019-01-26.log"
    destination = "/tmp/file.log"

    connection {
      type        = "${local.conn_type}"
      user        = "${local.conn_user}"
      private_key = "${local.conn_key}"
    }
  }

  provisioner "remote-exec" {
    inline = [
      "sleep 20",
      "echo \"[UPDATING THE SYSTEM]\"",
      "sudo yum update -y",
      "echo \"[INSTALLING HTTPD]\"",
      "sudo yum install -y httpd",
      "echo \"[STARTING HTTPD]\"",
      "sudo service httpd start",
      "sudo chkconfig httpd on",
      "echo \"[FINISHING]\"",
      "sleep 20",
    ]

    connection {
      type        = "${local.conn_type}"
      user        = "${local.conn_user}"
      private_key = "${local.conn_key}"
    }
  }
}

resource "null_resource" "null" {
  provisioner "local-exec" {
    command = "echo ${aws_instance.web.id}:${aws_instance.web.public_ip} >> public_ips.txt"
  }
}

resource "tls_private_key" "pkey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "keypair" {
  key_name   = "highdantas-${var.env}"
  public_key = "${tls_private_key.pkey.public_key_openssh}"
}

resource "aws_security_group" "tst-sg-alb" {
  name        = "tst-sg-alb"
  description = "Load Balancer SG"
  vpc_id      = "${aws_vpc.tst-vpc.id}"

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags {
    Name = "Load Balancer"
  }
}

resource "aws_lb" "tst-alb" {
  name            = "tst-alb"
  security_groups = ["${aws_security_group.tst-sg-alb.id}"]
  subnets         = ["${aws_subnet.tst-subnet-public-a.id}", "${aws_subnet.tst-subnet-public-b.id}"]

  tags {
    Name = "ALB"
  }
}

resource "aws_lb_target_group" "tst-tg-alb" {
  name     = "tst-tg-alb"
  port     = 80
  protocol = "HTTP"
  vpc_id   = "${aws_vpc.tst-vpc.id}"

  health_check {
    path              = "/"
    healthy_threshold = 2
  }
}

resource "aws_lb_listener" "tst-lbl" {
  load_balancer_arn = "${aws_lb.tst-alb.arn}"
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = "${aws_lb_target_group.tst-tg-alb.arn}"
  }
}

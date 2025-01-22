provider "aws" {
  region = "us-west-2"
}

terraform {
  backend "s3" {
    bucket         = "terraform-state-asg-remeziz"
    key            = "asg/terraform.tfstate"
    region         = "us-west-2"
    dynamodb_table = "terraform_lock"
    encrypt        = true
  }
}

resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
}

resource "aws_subnet" "main" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "us-west-2a"
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "main" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
}

resource "aws_route_table_association" "main" {
  subnet_id      = aws_subnet.main.id
  route_table_id = aws_route_table.main.id
}

resource "aws_security_group" "elb" {
  vpc_id = aws_vpc.main.id

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
}

resource "aws_security_group" "asg" {
  vpc_id = aws_vpc.main.id

  ingress {
    from_port       = 80
    to_port         = 80
    protocol        = "tcp"
    security_groups = [aws_security_group.elb.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_launch_template" "asg" {
  name          = "example-launch-template"
  image_id      = "ami-063d405eaa926874b"
  instance_type = "t4g.micro"
}

resource "aws_launch_template" "asg2" {
  name          = "example-launch-template-2"
  image_id      = "ami-063d405eaa926874b"
  instance_type = "t4g.micro"
}

resource "aws_autoscaling_group" "asg" {
  name                 = "ASG1"
  desired_capacity     = 0
  max_size             = 1
  min_size             = 0
  vpc_zone_identifier  = [aws_subnet.main.id]
  launch_template {
    id      = aws_launch_template.asg.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "example-asg-instance"
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "asg2" {
  name                 = "ASG2"
  desired_capacity     = 0
  max_size             = 1
  min_size             = 0
  vpc_zone_identifier  = [aws_subnet.main.id]
  launch_template {
    id      = aws_launch_template.asg2.id
    version = "$Latest"
  }

  tag {
    key                 = "Name"
    value               = "example-asg-instance-2"
    propagate_at_launch = true
  }
}

resource "aws_elb" "main" {
  name               = "example-elb"
  security_groups    = [aws_security_group.elb.id]
  subnets            = [aws_subnet.main.id]  # Ensure the ELB is in the correct subnet

  listener {
    instance_port     = 80
    instance_protocol = "HTTP"
    lb_port           = 80
    lb_protocol       = "HTTP"
  }

  health_check {
    target              = "HTTP:80/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  # Remove the instances attribute
  # instances = [aws_autoscaling_group.asg.id]
}

resource "aws_elb" "main2" {
  name               = "example-elb-2"
  security_groups    = [aws_security_group.elb.id]
  subnets            = [aws_subnet.main.id]  # Ensure the ELB is in the correct subnet

  listener {
    instance_port     = 80
    instance_protocol = "HTTP"
    lb_port           = 80
    lb_protocol       = "HTTP"
  }

  health_check {
    target              = "HTTP:80/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
  }

  # Remove the instances attribute
  # instances = [aws_autoscaling_group.asg2.id]
}

resource "aws_autoscaling_attachment" "asg_attachment" {
  autoscaling_group_name = aws_autoscaling_group.asg.name
  elb                    = aws_elb.main.name
}

resource "aws_autoscaling_attachment" "asg_attachment2" {
  autoscaling_group_name = aws_autoscaling_group.asg2.name
  elb                    = aws_elb.main2.name
}

output "asg_name_1" {
  value = aws_autoscaling_group.asg.name
}

output "asg_name_2" {
  value = aws_autoscaling_group.asg2.name
}


resource "aws_launch_template" "example_lt" {
  name_prefix   = "asg-example-lt-"
  image_id    = var.instance_profile
  instance_type = var.instance_type

  vpc_security_group_ids = [
    aws_security_group.ec2_sg.id
  ]

  # Если нужно - IAM Instance Profile
  # iam_instance_profile {
  #   name = "my-instance-profile"
  # }

  # Дополнительно - user_data (скрипт cloud-init и т.п.)
  # user_data = file("user_data.sh")

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "asg-example-instance"
    }
  }
}

resource "aws_autoscaling_group" "this" {
  name                      = "asg-aws"
  max_size                  = var.max_size
  min_size                  = var.min_size
  desired_capacity          = var.desired_capacity
  vpc_zone_identifier       = var.default_subnet
  launch_configuration      = aws_launch_configuration.this.name
  target_group_arns         = var.target_group_arns

  # Health Check
  health_check_type         = "EC2"
  health_check_grace_period = var.health_check_grace_period

  # Чтобы Terraform мог пересоздать ASG без downtime
  lifecycle {
    create_before_destroy = true
  }

  tag {
    key                 = "Name"
    value               = "asg-aws"
    propagate_at_launch = true
  }
}
###############################################################################
# Вывод DNS-имени ALB
###############################################################################
output "alb_dns_name" {
  description = "DNS-имя нашего Application Load Balancer"
  value       = aws_lb.this.dns_name
}
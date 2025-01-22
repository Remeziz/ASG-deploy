output "asg_names" {
  value = [
    aws_autoscaling_group.asg.name,
    aws_autoscaling_group.asg2.name
  ]
  description = "List of Auto Scaling Group names"
}
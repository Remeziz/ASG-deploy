output "asg_names" {
  value       = [aws_autoscaling_group.asg.name, aws_autoscaling_group.asg2.name]
  description = "Names of the Auto Scaling Groups"
}


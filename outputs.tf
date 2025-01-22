output "asg_name_1" {
  value       = aws_autoscaling_group.asg.name
  description = "Name of the first Auto Scaling Group"
}

output "asg_name_2" {
  value       = aws_autoscaling_group.asg2.name
  description = "Name of the second Auto Scaling Group"
}
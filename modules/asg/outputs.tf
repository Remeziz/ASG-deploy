output "asg_name" {
  description = "Имя созданной Auto Scaling Group"
  value       = aws_autoscaling_group.this.name
}
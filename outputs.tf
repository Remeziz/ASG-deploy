output "asg_names" {
  value       = [aws_autoscaling_group.asg.name, aws_autoscaling_group.asg2.name]
  description = "Names of the Auto Scaling Groups"
}

output "ssh_private_key" {
  value       = tls_private_key.deployer.private_key_pem
  description = "Private SSH key for accessing instances"
  sensitive   = true
}
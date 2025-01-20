variable "instance_name" {
  type        = string
  default     = "My Host"
  description = "My instance's name"
}

variable "instance_type" {
  type        = string
  default     = "t2.micro"
  description = "My instance's name"
}

variable "root_block_size" {
  type        = number
  default     = null
  description = "description"
}

variable "root_volume_type" {
  type        = string
  default     = "gp2"
  description = "description"
}

variable "instance_profile" {
  type    = string
  default = null
}

variable "security_group_id" {
  type = string
}

variable "default_subnet" {
  default = "subnet-0c5ead20fa23df89b"
}

variable "ami_id" {
  type        = string
  description = "ID AMI для EC2"
}

variable "instance_type" {
  type        = string
  description = "EC2 instance type"
  default     = "t2.micro"
}

variable "instance_security_groups" {
  type        = list(string)
  description = "Список Security Groups для инстансов"
  default     = []
}



variable "min_size" {
  type        = number
  description = "Минимальное число инстансов в ASG"
  default     = 1
}

variable "max_size" {
  type        = number
  description = "Максимальное число инстансов в ASG"
  default     = 2
}

variable "desired_capacity" {
  type        = number
  description = "Желаемое число инстансов в ASG"
  default     = 1
}

variable "health_check_grace_period" {
  type        = number
  description = "Сколько секунд даётся инстансу после запуска на health check"
  default     = 300
}

variable "target_group_arns" {
  type        = list(string)
  description = "Список ARN Target Groups, к которым будет подключаться ASG"
  default     = []
}
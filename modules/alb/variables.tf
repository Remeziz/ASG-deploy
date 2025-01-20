variable "name" {
  type        = string
  description = "description"
}

variable "supported_instance_types" {
  type    = list(string)
  default = ["t2.micro"]
}

variable "instance_ids" {
  type    = list(string)
  default = []
}

variable "instance_sg_id" {
  type = string
}


variable "my_ip" {
  type = string
}

variable "from_port_tg" {
  type        = string
  default     = "8080"
  description = "listen port for target group"
}

variable "to_port_tg" {
  type        = string
  default     = "8080"
  description = "to port for target group"
}

variable "from_listen_alb_port" {
  type        = string
  default     = "80"
  description = "from alb listen port"
}

variable "to_listen_alb_port" {
  type        = string
  default     = "80"
  description = "to alb listen port"
}
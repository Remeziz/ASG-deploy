terraform {
  backend "s3" {
    bucket         = "hillel-devops-terraform-state-2"
    key            = "lesson25/terraform/terraform.tfstate"
    region         = "us-west-1"
    encrypt        = true
    dynamodb_table = "my-terraform-lock-table"
  }
}

provider "aws" {
  region = "us-west-1"
}

module "alb" {
  source = "./modules/alb"

  name           = "alb-asg"
  my_ip          = "${local.my_ip}"
  instance_ids   = [for host in module.my_host : host.instance_id]
  instance_sg_id = aws_security_group.my_host.id
}

module "my_host" {
  source = "./modules/instance"

  for_each = {
    "first_instance" : {
      "instance_type" : "t2.micro",
      "root_block_size" : 10,
      "root_volume_type" : "gp3"
    },
    # "second_instance" : {
    #   "instance_type" : "t2.micro",
    #   "root_block_size" : 10,
    #   "root_volume_type" : "gp3"
    # },
  }
  
  instance_name          = each.key
  instance_type          = each.value.instance_type
  root_block_size        = each.value.root_block_size
  root_volume_type       = lookup(each.value, "root_volume_type", "standard")
  security_group_id      = aws_security_group.my_host.id
}

module "asg" {
  source            = "./modules/asg"
  
  min_size          = 1
  max_size          = 3
  desired_capacity  = 2
  health_check_grace_period = 300

}

data "aws_vpc" "this" {
  filter {
    name   = "isDefault"
    values = ["true"]
  }
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}
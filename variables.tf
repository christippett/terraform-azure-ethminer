variable "ssh_key" {
  type    = "string"
  default = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQCzCdiWhldlA4Pc3jaTgD5RSt4Bpmnr4BeyA5R/GbfNxkWFHVGFbkqwI/rSh6m7VSa6wWVkG7AllRc+OfsCqWvCHpZmOigTZS1wiHOBwqJfW7xNGindUjuizOfAkvJEolA+wyH69oyDE2RGClbT4m/sp4634L9tLATWEGqNyKjJE0qDIDD+1aYQQKzTJ4SiyitPac1vl2bUAXa6SA8SXghO5liVPw4LqI1GgPAwEcIpjJgnlVyVjXYiahsKIAAC0VbJYfwe6Yy75esYWYKEvNw5e7zv1L0cYa+mc8t2cWGNHGjQKQ456YdO7N0ZcZcckE3/1kwnq0Sh+jbK+fi1SPnd christippett@administrators-MacBook-Pro.local"
}

variable "region" {
  type    = "string"
  default = "South Central US"
}

variable "prefix" {
  type    = "string"
  default = "ether-"
}

variable "subnet_cidr" {
  type    = "string"
  default = "10.0.2.0/24"
}

variable "instance_count" {
  type    = "string"
  default = "7"
}

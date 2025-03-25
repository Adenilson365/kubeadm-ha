variable "vpc_name" {
  default = "vpc-tf"
}

variable "subnet_name" {
  default = "subnet-tf"
}

variable "firewall_name" {
  default = "tf-firewall"
}

variable "vpc_regions" {
  type = set(string)
}


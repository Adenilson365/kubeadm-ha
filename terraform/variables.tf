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



variable "vm_machine_type" {
  type = string
  default = "e2-medium"
  
}

variable "vm_zone_workers" {
  type = string
  default = "us-west1-a"
  
}
variable "vm_zone_masters" {
  type = string
  default = "us-central1-a"
  
}
variable "vm_zone_haproxy" {
  type = string
  default = "us-east1-b"
  
}
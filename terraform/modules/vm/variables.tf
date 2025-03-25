variable "vm_name" {
  type = string
  default = "k8s-vm"
}

variable "vm_machine_type" {
  type = string
}

variable "vm_network_name" {
  type = string
  default = "default"
}
variable "vm_subnet_name" {
  type = string
  default = "default"
}

variable "vm_hostname" {
  type = string
}

variable "file_startup_script" {
}

variable "use_public_ip" {
  type = bool
  default = false
}

variable "vm_zone" {
  type = string
}
module "network-gcp" {
  source        = "./modules/network"
  vpc_name      = var.vpc_name
  subnet_name   = var.subnet_name
  firewall_name = var.firewall_name
  vpc_regions   = var.vpc_regions


}



module "vm-master" {
  source            = "./modules/vm"
  vm_name           = "master-${count.index}"
  vm_machine_type   = "e2-standard-4"
  vm_network_name   = var.vpc_name
  vm_subnet_name    = "subnet-us-central1"
  vm_zone = var.vm_zone_masters
  vm_hostname       = "master${count.index}.node"
  file_startup_script = file("./install-kubeadm.sh")
  depends_on = [ module.network-gcp ]
  count = 1

}

module "vm-worker" {
  source            = "./modules/vm"
  vm_name           = "worker-${count.index}"
  vm_machine_type   = "e2-medium"
  vm_network_name   = var.vpc_name
  vm_subnet_name    = "subnet-us-west1"
  vm_hostname       = "worker${count.index}.node"
  vm_zone = var.vm_zone_workers
  file_startup_script = file("./install-kubeadm.sh")
  depends_on = [ module.network-gcp ]
  count = 1

}

module "vm-haproxy-adm" {
  source            = "./modules/vm"
  vm_name           = "haproxy-adm-${count.index}"
  vm_machine_type   = "e2-medium"
  vm_network_name   = var.vpc_name
  vm_subnet_name    = "subnet-us-east1"
  vm_hostname       = "haproxyadm${count.index}.node"
  vm_zone = var.vm_zone_haproxy
  file_startup_script = file("./start.sh")
  depends_on = [ module.network-gcp ]
  count = 0
  use_public_ip = true
}

module "vm-haproxy-app" {
  source            = "./modules/vm"
  vm_name           = "haproxy-app-${count.index}"
  vm_machine_type   = "e2-medium"
  vm_network_name   = var.vpc_name
  vm_subnet_name    = "subnet-us-east1"
  vm_zone = var.vm_zone_haproxy
  vm_hostname       = "haproxyapp${count.index}.node"
  file_startup_script = file("./start.sh")
  depends_on = [ module.network-gcp ]
  count = 0
  use_public_ip = true
}


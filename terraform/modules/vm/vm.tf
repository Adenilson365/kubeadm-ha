resource "google_compute_instance" "vm-default" {
  name = var.vm_name
  machine_type = var.vm_machine_type
  hostname = var.vm_hostname
  zone = var.vm_zone

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-11"
    }
  }
  network_interface {
    network = var.vm_network_name
    subnetwork = var.vm_subnet_name
  dynamic "access_config" {
        for_each = var.use_public_ip ? [1] : []
        content {}
      }
  }
    tags = ["master","worker","haproxyadm","haproxyapp"]
  metadata_startup_script = var.file_startup_script
    metadata = {
        ssh-keys = "admin:${file("~/.ssh/id_rsa.pub")}"
    }
}
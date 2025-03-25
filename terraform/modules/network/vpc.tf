resource "google_compute_network" "vpc_network" {
  name                    = var.vpc_name
  auto_create_subnetworks = false
  mtu                     = 1460
}

resource "google_compute_subnetwork" "vpc_subnet" {
  name          = "subnet-${each.key}"
  network       = google_compute_network.vpc_network.id
  ip_cidr_range = "10.0.${index(tolist(var.vpc_regions), each.key)}.0/24"
  region        = each.key
  for_each      = var.vpc_regions

}


resource "google_compute_firewall" "tf-firewall" {
  name    = var.firewall_name
  network = google_compute_network.vpc_network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "22", "443", "5432"]
  }

  target_tags = ["worker", "master", "haproxyadm", "haproxyapp"]

  source_ranges = ["0.0.0.0/0"]
}


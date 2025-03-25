
# Uma rota por nat
resource "google_compute_router" "nat_router" {
  for_each = var.vpc_regions  
  name    = "nat-router-${each.key}"
  network = google_compute_network.vpc_network.id
  region  = each.key
}

# Criar Cloud NAT para cada router - para cada subnet
resource "google_compute_router_nat" "cloud_nat" {
  for_each                   = google_compute_router.nat_router
  name                       = "cloud-nat-${each.key}"
  router                     = each.value.name
  region                     = each.value.region
  nat_ip_allocate_option     = "AUTO_ONLY"  
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}
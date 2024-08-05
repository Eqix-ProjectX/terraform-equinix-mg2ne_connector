# setup for metal environment
resource "equinix_metal_vrf" "myvrf" {
  description = var.vrf_desc
  name        = var.vrf_name
  metro       = var.metro
  local_asn   = var.vrf_asn
  ip_ranges   = var.vrf_ranges
  project_id  = var.project_id
}

resource "equinix_metal_vlan" "myvlan" {
  description = var.vlan_desc
  metro       = var.metro
  project_id  = var.project_id
}

resource "equinix_metal_reserved_ip_block" "myrange" {
  description = var.range_desc
  project_id  = var.project_id
  metro       = var.metro
  type        = "vrf"
  vrf_id      = equinix_metal_vrf.myvrf.id
  cidr        = var.cidr
  network     = var.network_range
}

resource "equinix_metal_gateway" "mygateway" {
  project_id        = var.project_id
  vlan_id           = equinix_metal_vlan.myvlan.id
  ip_reservation_id = equinix_metal_reserved_ip_block.myrange.id
}





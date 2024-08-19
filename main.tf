# setup for metal environment
resource "equinix_metal_vrf" "myvrf_pri" {
  description = var.vrf_desc
  name        = var.vrf_name
  metro       = var.metro
  local_asn   = var.vrf_asn
  ip_ranges   = var.vrf_ranges
  project_id  = var.project_id
}

resource "equinix_metal_vrf" "myvrf_sec" {
  description = var.vrf_desc_sec
  name        = var.vrf_name_sec
  metro       = var.metro
  local_asn   = var.vrf_asn
  ip_ranges   = var.vrf_ranges_sec
  project_id  = var.project_id
}

resource "equinix_metal_vlan" "myvlan_pri" {
  description = var.vlan_desc
  metro       = var.metro
  project_id  = var.project_id
}

resource "equinix_metal_vlan" "myvlan_sec" {
  description = var.vlan_desc_sec
  metro       = var.metro
  project_id  = var.project_id
}

resource "equinix_metal_reserved_ip_block" "myrange" {
  description = var.range_desc
  project_id  = var.project_id
  metro       = var.metro
  type        = "vrf"
  vrf_id      = equinix_metal_vrf.myvrf_pri.id
  cidr        = var.cidr
  network     = var.network_range
}

# resource "equinix_metal_reserved_ip_block" "myrange_sec" {
#   description = var.range_desc_sec
#   project_id  = var.project_id
#   metro       = var.metro
#   type        = "vrf"
#   vrf_id      = equinix_metal_vrf.myvrf_sec.id
#   cidr        = var.cidr
#   network     = var.network_range
# }

resource "equinix_metal_gateway" "mygateway_pri" {
  project_id        = var.project_id
  vlan_id           = equinix_metal_vlan.myvlan_pri.id
  ip_reservation_id = equinix_metal_reserved_ip_block.myrange.id
}

resource "equinix_metal_gateway" "mygateway_sec" {
  project_id        = var.project_id
  vlan_id           = equinix_metal_vlan.myvlan_sec.id
  ip_reservation_id = equinix_metal_reserved_ip_block.myrange.id
}



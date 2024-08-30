# setup for metal environment
resource "equinix_metal_vrf" "myvrf_pri" {
  description = var.vrf_desc_pri
  name        = var.vrf_name_pri
  metro       = var.metro
  local_asn   = var.vrf_asn
  ip_ranges   = cidrsubnets(format("%s%s", var.network_range_pri, "/24"), 1, 1)
  project_id  = var.project_id
}

resource "equinix_metal_vrf" "myvrf_sec" {
  description = var.vrf_desc_sec
  name        = var.vrf_name_sec
  metro       = var.metro
  local_asn   = var.vrf_asn
  ip_ranges   = cidrsubnets(format("%s%s", var.network_range_sec, "/24"), 1, 1)
  project_id  = var.project_id
}

resource "equinix_metal_vlan" "myvlan_pri" {
  description = var.vlan_desc_pri
  metro       = var.metro
  project_id  = var.project_id
}

resource "equinix_metal_vlan" "myvlan_sec" {
  description = var.vlan_desc_sec
  metro       = var.metro
  project_id  = var.project_id
}

resource "equinix_metal_reserved_ip_block" "myrange_pri" {
  description = var.range_desc_pri
  project_id  = var.project_id
  metro       = var.metro
  type        = "vrf"
  vrf_id      = equinix_metal_vrf.myvrf_pri.id
  cidr        = var.cidr
  network     = var.network_range_pri
}

resource "equinix_metal_reserved_ip_block" "myrange_sec" {
  description = var.range_desc_sec
  project_id  = var.project_id
  metro       = var.metro
  type        = "vrf"
  vrf_id      = equinix_metal_vrf.myvrf_sec.id
  cidr        = var.cidr
  network     = var.network_range_sec
}

resource "equinix_metal_gateway" "mygateway_pri" {
  project_id        = var.project_id
  vlan_id           = equinix_metal_vlan.myvlan_pri.id
  ip_reservation_id = equinix_metal_reserved_ip_block.myrange_pri.id
}

resource "equinix_metal_gateway" "mygateway_sec" {
  project_id        = var.project_id
  vlan_id           = equinix_metal_vlan.myvlan_sec.id
  ip_reservation_id = equinix_metal_reserved_ip_block.myrange_sec.id
}

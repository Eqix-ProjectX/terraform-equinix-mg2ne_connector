data "equinix_network_device" "vd_pri" {
  name = "vd-${var.metro_code}-${var.username}-pre"
}
data "equinix_network_device" "vd_sec" {
  name = "vd-${var.sec_metro_code}-${var.username}-sec"
}

# IOS-XE configuration
provider "iosxe" {
  alias    = "vd_pri"
  username = "${var.username}"
  password = "${data.equinix_network_device.vd_pri.vendor_configuration.adminPassword}"
  url      = "https://${data.equinix_network_device.vd_pri.ssh_ip_address}"
}
provider "iosxe" {
  alias    = "vd_sec"
  username = "${var.username}"
  password = "${data.equinix_network_device.vd_sec.vendor_configuration.adminPassword}"
  url      = "https://${data.equinix_network_device.vd_sec.ssh_ip_address}"
}

resource "iosxe_interface_ethernet" "interface" {
  type                           = "GigabitEthernet"
  name                           = var.int
  bandwidth                      = var.bw
  description                    = var.int_desc
  shutdown                       = false
  ip_proxy_arp                   = false
  ip_redirects                   = false
  ip_unreachables                = false
  ipv4_address                   = cidrhost("${var.network_range}/${var.cidr}", 3)
  ipv4_address_mask              = var.cidr
  snmp_trap_link_status            = true
  logging_event_link_status_enable = true
}

resource "iosxe_bgp" "bgp" {
  asn                  = var.vnf_asn
  log_neighbor_changes = true
}

resource "iosxe_bgp_address_family_ipv4" "ipv4" {
  asn                   = var.vnf_asn
  af_name               = "unicast"
  ipv4_unicast_redistribute_connected = true
  ipv4_unicast_redistribute_static = true  
}

resource "iosxe_bgp_ipv4_unicast_neighbor" "neighbor" {
  asn                   = var.vrf_asn
  ip                    = cidrhost("${var.network_range}/${var.cidr}", 2)
  activate                = true
  soft_reconfiguration = "inbound"
}

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





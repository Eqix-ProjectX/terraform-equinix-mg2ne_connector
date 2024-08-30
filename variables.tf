variable "metro" {}
variable "vrf_desc_pri" {}
variable "vrf_desc_sec" {}
variable "vrf_name_pri" {}
variable "vrf_name_sec" {}
variable "vrf_asn" {}
# variable "vrf_ranges_pri" {
#     default = cidrsubnet(var.network_range_pri, 2, 1)
# }
# variable "vrf_ranges_sec" {
#     default = cidrsubnet(var.network_range_sec, 2, 1)
# }
variable "project_id" {}
variable "vlan_desc_pri" {}
variable "vlan_desc_sec" {}
variable "range_desc_pri" {}
variable "range_desc_sec" {}
variable "cidr" {}
variable "network_range_pri" {}
variable "network_range_sec" {}
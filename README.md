# terraform-equinix-mg2ne_connector

Based on the scrum project within EMEA/APAC TAM.   Provisioning certain numbers of instances and vnf per your need.

## :watermelon: Instruction

This module will realize the interconnectivity between metal gateway and the NE with BGP peering.
In the **terraform.tfvars** in the root module you may want to specify below as a variable.

- `metro` where your baremetal lives at
- `vrf_desc` description of vrf entity
- `vrf_name` name of vrf
- `vrf_asn` ASN of vrf
- `vrf_ranges` IP ranges of vrf
- `project_id` which your instance spinned up with
- `vlan_desc` description of metal vlan
- `range_desc` description of IP range
- `cidr` cidr of IP ranges you reserve
- `network_range` IP range itself


It acts nothing more than above at the time writing the code today.   There will be more to come.

**terraform.tfvars** (sample)
```terraform
metro="SG"
vrf_desc="sample"
vrf_name="sample"
vrf_asn="65000"
vrf_ranges=["192.168.0.0/25", "192.168.1.0/25"]
project_id="your project_id"
vlan_desc="sample"
range_desc="sample"
cidr=29
network_range="192.168.0.0"
```  


>[!note]
>Declare your credential as environment variables before you run.  
>`export EQUINIX_API_CLIENTID=someEquinixAPIClientID`  
>`export EQUINIX_API_CLIENTSECRET=someEquinixAPIClientSecret`  
>`export METAL_AUTH_TOKEN=someEquinixMetalToken`

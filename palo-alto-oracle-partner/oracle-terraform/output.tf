# Output the result of ADs
output "show-ads" {
  value = data.oci_identity_availability_domains.ads.availability_domains
}

# Output the result of VCNs
output "show-vcns" {
  value = data.oci_core_vcns.vcns.virtual_networks
}

# # Output the result of New VCNs
# output "show-vcns-new" {
#   value = data.oci_core_vcns.vcns_new.virtual_networks
# }
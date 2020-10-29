# Configure the Oracle Cloud Infrastructure provider with an API Key
provider "oci" {
  tenancy_ocid = var.tenancy_ocid
  user_ocid = var.user_ocid
  fingerprint = var.fingerprint
  private_key_path = var.private_key_path
  region = var.region
}

# Get a list of Availability Domains
data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

# Get a list of VCNs
data "oci_core_vcns" "vcns" {
    compartment_id = var.tenancy_ocid
}

# Create a Subnet in VCN
resource "oci_core_vcn" "test_vcn" {
    cidr_block = var.vcn_cidr_block
    compartment_id = var.tenancy_ocid
    display_name = var.vcn_display_name
}
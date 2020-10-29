
// User OCID 
variable "tenancy_ocid" {
  description = "Oracle Tenant OCI."
  type        = string
  default     = "XXXX"
}

// User OCID 
variable "user_ocid" {
  description = "Oracle User OCID."
  type        = string
  default     = "XXXX"
}


// User Region 
variable "region" {
  description = "Oracle region name."
  type        = string
  default     = "us-sanjose-1"
}

// User Private key
variable "private_key_path" {
  default = "/Users/apoonia/.oci/oci_api_key.pem"
}

// User Private key
variable "fingerprint" {
  default = "XXXX"
}

// VCN Network
variable "vcn_cidr_block" {
  default = "10.20.0.0/16"
}

// VCN Network
variable "vcn_display_name" {
  default = "Created-From-Terraform"
}
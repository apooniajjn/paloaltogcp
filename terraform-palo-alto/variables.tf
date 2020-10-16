variable "project_id" {
  description = "Google Cloud Platform (GCP) Project ID."
  type        = string
}

variable "region" {
  description = "GCP region name."
  type        = string
  default     = "us-central1"
}

variable "zone" {
  description = "GCP zone name."
  type        = string
  default     = "us-central1-c"
}

variable "web_name" {
  description = "Web server name."
  type        = string
  default     = "my-webserver"
}

variable "db_name" {
  description = "Db server name."
  type        = string
  default     = "my-dbserver"
}

variable "machine_type" {
  description = "GCP VM instance machine type."
  type        = string
  default     = "f1-micro"
}

variable "labels" {
  description = "List of labels to attach to the VM instance."
  type        = map
}
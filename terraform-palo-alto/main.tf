provider "google" {
  credentials = file("credentials.json")
  version =     ">= 3.42.0"
  project     = var.my_gcp_project
  region      = var.region
}

// DB and Web Image 
data "google_compute_image" "debian" {
  family  = "debian-10"
  project = "debian-cloud"
}

// Terraform plugin for creating random ids
resource "random_id" "instance_id" {
 byte_length = 8
}

// Adding SSH Public Key in Project Meta Data
resource "google_compute_project_metadata_item" "ssh-keys" {
  key   = "sshkeys"
  value = file(var.public_key)
}

// Adding VPC Networks to Project  MANAGEMENT
resource "google_compute_subnetwork" "management-sub" {
  name          = "management-subnet"
  ip_cidr_range = "10.5.0.0/24"
  network       = google_compute_network.management.self_link
  region        = var.region
}

resource "google_compute_network" "management" {
  name                    = var.interface_0_name
  auto_create_subnetworks = "false"
}

// Adding VPC Networks to Project  UNTRUST
resource "google_compute_subnetwork" "untrust-sub" {
  name          = "untrust-subnet"
  ip_cidr_range = "10.5.1.0/24"
  network       = google_compute_network.untrust.self_link
  region        = var.region
}

resource "google_compute_network" "untrust" {
  name                    = var.interface_1_name
  auto_create_subnetworks = "false"
}

// Adding VPC Networks to Project  WEB_TRUST 
resource "google_compute_subnetwork" "web-trust-sub" {
  name          = "web-subnet"
  ip_cidr_range = "10.5.2.0/24"
  network       = google_compute_network.web.self_link
  region        = var.region
}

resource "google_compute_network" "web" {
  name                    = var.interface_2_name
  auto_create_subnetworks = "false"
}

// Adding VPC Networks to Project  DB_TRUST 
resource "google_compute_subnetwork" "db-trust-sub" {
  name          = "db-subnet"
  ip_cidr_range = "10.5.3.0/24"
  network       = google_compute_network.db.self_link
  region        = var.region
}

resource "google_compute_network" "db" {
  name                    = var.interface_3_name
  auto_create_subnetworks = "false"
}

# // Adding GCP ROUTE to WEB Interface
# resource "google_compute_route" "web-route" {
#   name                   = "web-route"
#   dest_range             = "0.0.0.0/0"
#   network                = google_compute_network.web.self_link
#   next_hop_instance      = var.firewall_name
#   next_hop_instance_zone = var.zone
#   priority               = 100

#   depends_on = [
#     google_compute_instance.firewall,
#     google_compute_network.web,
#     google_compute_network.db,
#     google_compute_network.untrust,
#     google_compute_network.management,
#   ]
# }

# // Adding GCP ROUTE to DB Interface
# resource "google_compute_route" "db-route" {
#   name                   = "db-route"
#   dest_range             = "0.0.0.0/0"
#   network                = google_compute_network.db.self_link
#   next_hop_instance      = var.firewall_name
#   next_hop_instance_zone = var.zone
#   priority               = 100

#   depends_on = [
#     google_compute_instance.firewall,
#     google_compute_network.web,
#     google_compute_network.db,
#     google_compute_network.untrust,
#     google_compute_network.management,
#   ]
# }

// Adding GCP Firewall Rules for MANGEMENT
resource "google_compute_firewall" "allow-mgmt" {
  name    = "allow-mgmt"
  network = google_compute_network.management.self_link

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["443", "22"]
  }

  source_ranges = ["0.0.0.0/0"]
}

// Adding GCP Firewall Rules for INBOUND
resource "google_compute_firewall" "allow-inbound" {
  name    = "allow-inbound"
  network = google_compute_network.untrust.self_link

  allow {
    protocol = "tcp"
    ports    = ["80", "22", "221", "222"]
  }

  source_ranges = ["0.0.0.0/0"]
}

// Adding GCP Firewall Rules for OUTBOUND
resource "google_compute_firewall" "web-allow-outbound" {
  name    = "web-allow-outbound"
  network = google_compute_network.web.self_link

  allow {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
}

// Adding GCP Firewall Rules for OUTBOUND
resource "google_compute_firewall" "db-allow-outbound" {
  name    = "db-allow-outbound"
  network = google_compute_network.db.self_link

  allow {
    protocol = "all"
  }

  source_ranges = ["0.0.0.0/0"]
}

// Create a bucket to hold startup scripts
resource "google_storage_bucket" "palo-alto-db" {
  name          = "palo-alto-db-${random_id.instance_id.hex}"
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 3
    }
    action {
      type = "Delete"
    }
  }
}

// Add files to startup script 
resource "google_storage_bucket_object" "db" {
  name   = "dbfile"
  source = "./startup-scripts/nginx.sh"
  bucket = google_storage_bucket.palo-alto-db.name
}

// Create a bucket to hold startup scripts
resource "google_storage_bucket" "palo-alto-web" {
  name          = "palo-alto-web-${random_id.instance_id.hex}"
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 3
    }
    action {
      type = "Delete"
    }
  }
}

resource "google_storage_bucket_object" "web" {
  name   = "webfile"
  source = "./startup-scripts/nginx.sh"
  bucket = google_storage_bucket.palo-alto-web.name
}


// Create a bucket to hold startup scripts
resource "google_storage_bucket" "palo-alto-firewall" {
  name          = "palo-alto-firewall-${random_id.instance_id.hex}"
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 3
    }
    action {
      type = "Delete"
    }
  }
}

resource "null_resource" "upload_firewall_file" {
  provisioner "local-exec" {
    command = "gsutil cp -r ./bootstrap/* ${google_storage_bucket.palo-alto-firewall.url}/"
  }
}

// Create Cloud DB NAT Gateway
resource "google_compute_router" "db-router" {
  name    = "db-router"
  region  = var.region
  network = google_compute_network.db.self_link
}

resource "google_compute_router_nat" "db-nat" {
  name                               = "db-router-nat"
  router                             = google_compute_router.db-router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}


// Create Cloud Web NAT Gateway
resource "google_compute_router" "web-router" {
  name    = "web-router"
  region  = var.region
  network = google_compute_network.web.self_link
}

resource "google_compute_router_nat" "web-nat" {
  name                               = "web-router-nat"
  router                             = google_compute_router.web-router.name
  region                             = var.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}

// Create a new Palo Alto Networks NGFW VM-Series GCE instance
resource "google_compute_instance" "firewall" {
  name                      = var.firewall_name
  machine_type              = var.machine_type_fw
  zone                      = var.zone
  min_cpu_platform          = var.machine_cpu_fw
  can_ip_forward            = true
  allow_stopping_for_update = true
  count                     = 1
  labels       = var.labels

  // Adding METADATA Key Value pairs to VM-Series GCE instance
  metadata =  {
    vmseries-bootstrap-gce-storagebucket = google_storage_bucket.palo-alto-firewall.url
    serial-port-enable                   = true
    sshKeys                              = file(var.public_key)
  }

  service_account {
    scopes = var.scopes_fw
  }

  network_interface {
    subnetwork    = google_compute_subnetwork.management-sub.self_link
    # access_config = {}
    access_config {
      // Ephemeral IP
    }
  }

  network_interface {
    subnetwork    = google_compute_subnetwork.untrust-sub.self_link
    network_ip       = "10.5.1.4"
    # access_config = {}
  }

  network_interface {
    subnetwork = google_compute_subnetwork.web-trust-sub.self_link
    network_ip    = "10.5.2.4"
  }

  network_interface {
    subnetwork = google_compute_subnetwork.db-trust-sub.self_link
    network_ip    = "10.5.3.4"
  }

  boot_disk {
    initialize_params {
      image = var.image_fw
    }
  }
}

// Create a new DBSERVER instance
resource "google_compute_instance" "dbserver" {
  name                      = var.db_server_name
  machine_type              = var.machine_type_db
  zone                      = var.zone
  can_ip_forward            = true
  allow_stopping_for_update = true
  count                     = 1
  labels       = var.labels

  // Adding METADATA Key Value pairs to DB-SERVER 
  metadata = {
    startup-script-url = "${google_storage_bucket.palo-alto-db.url}/dbfile"
    serial-port-enable = true
    sshKeys = file(var.public_key)
  }

  service_account {
    scopes = var.scopes_db
  }

  network_interface {
    subnetwork = google_compute_subnetwork.db-trust-sub.self_link
    network_ip    = var.ip_db
  }

  boot_disk {
    initialize_params {
      image = data.google_compute_image.debian.self_link
    }
  }

  depends_on = [
    google_compute_instance.firewall,
    google_compute_network.web,
    google_compute_network.db,
    google_compute_network.untrust,
    google_compute_network.management,
  ]
}



// Create a new WEB SERVER instance
resource "google_compute_instance" "webserver" {
  name                      = var.web_server_name
  machine_type              = var.machine_type_web
  zone                      = var.zone
  can_ip_forward            = true
  allow_stopping_for_update = true
  count                     = 1
  labels       = var.labels

  // Adding METADATA Key Value pairs to WEB SERVER 
  metadata = {
    startup-script-url = "${google_storage_bucket.palo-alto-web.self_link}/webfile"
    serial-port-enable = true
    sshKeys = file(var.public_key)
  }

  service_account {
    scopes = var.scopes_web
  }

  network_interface {
    subnetwork = google_compute_subnetwork.web-trust-sub.self_link
    network_ip    = var.ip_web
  }

  boot_disk {
    initialize_params {
      image = data.google_compute_image.debian.self_link
    }
  }

  depends_on = [
    google_compute_instance.firewall,
    google_compute_network.web,
    google_compute_network.db,
    google_compute_network.untrust,
    google_compute_network.management,
  ]
}

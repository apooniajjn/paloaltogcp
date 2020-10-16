provider "google" {
  credentials = file("credentials.json")
  project     = "my-user-project-284920"
  region  = "us-central1"
  zone    = "us-central1-c"
}

data "google_compute_image" "debian" {
  family  = "ubuntu-1804-lts"
  project = "gce-uefi-images"
}

// Terraform plugin for creating random ids
resource "random_id" "instance_id" {
 byte_length = 8
}

resource "google_compute_subnetwork" "db-subnet" {
  name          = "db-subnet"
  ip_cidr_range = "10.5.3.0/24"
  region        = "us-central1"
  network       = google_compute_network.db-network.id
}
resource "google_compute_network" "db-network" {
  name                    = "db-network"
  auto_create_subnetworks = false
}

resource "google_compute_firewall" "allow-icmp-db" {
  name    = "icmp-db-firewall"
  network = google_compute_network.db-network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "1000-2000"]
  }
}

resource "google_compute_firewall" "allow-ingress-from-iap-db" {
  name    = "ingress-from-iap-firewall-db"
  direction = "INGRESS"
  network = google_compute_network.db-network.name
  source_ranges = ["35.235.240.0/20"]

  allow {
    protocol = "tcp"
    ports    = ["22", "3389"]
  }

}

resource "google_compute_subnetwork" "web-subnet" {
  name          = "web-subnet"
  ip_cidr_range = "10.5.4.0/24"
  region        = "us-central1"
  network       = google_compute_network.web-network.id
}
resource "google_compute_network" "web-network" {
  name                    = "web-network"
  auto_create_subnetworks = false
}

resource "google_compute_firewall" "allow-icmp-web" {
  name    = "icmp-web-firewall"
  network = google_compute_network.web-network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    ports    = ["80", "8080", "1000-2000"]
  }

}

resource "google_compute_firewall" "allow-ingress-from-iap-web" {
  name    = "ingress-from-iap-firewall-web"
  direction = "INGRESS"
  network = google_compute_network.web-network.name
  source_ranges = ["35.235.240.0/20"]

  allow {
    protocol = "tcp"
    ports    = ["22", "3389"]
  }

}

# Creates a GCP VM Instance.
resource "google_compute_instance" "dbvm" {
  name         = var.db_name
  machine_type = var.machine_type
  zone         = var.zone
  tags         = ["http-server"]
  labels       = var.labels

  boot_disk {
    initialize_params {
      image = data.google_compute_image.debian.self_link
    }
  }

  network_interface {
    network = "db-network"
    subnetwork = "db-subnet"
    access_config {
      // Ephemeral IP
    }
  }

  metadata_startup_script = data.template_file.nginx.rendered
}

# Creates a GCP VM Instance.
resource "google_compute_instance" "webvm" {
  name         = var.web_name
  machine_type = var.machine_type
  zone         = var.zone
  tags         = ["http-server"]
  labels       = var.labels

  boot_disk {
    initialize_params {
      image = data.google_compute_image.debian.self_link
    }
  }

  network_interface {
    network = "web-network"
    subnetwork = "web-subnet"
    access_config {
      // Ephemeral IP
    }
  }

  metadata_startup_script = data.template_file.nginx.rendered
}
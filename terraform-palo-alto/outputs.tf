output "webserver_ip" {
value = google_compute_instance.webvm.network_interface.0.access_config.0.nat_ip
}

output "dbserver_ip" {
value = google_compute_instance.dbvm.network_interface.0.access_config.0.nat_ip
}
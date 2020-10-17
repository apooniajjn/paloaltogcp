# output "webserver_ip" {
# value = google_compute_instance.webvm.network_interface.0.access_config.0.nat_ip
# }

# output "dbserver_ip" {
# value = google_compute_instance.dbvm.network_interface.0.access_config.0.nat_ip
# }

# output "firewall-web-trust-ip" {
#   value = google_compute_instance.firewall.network_interface.2.network_ip
# }

# output "firewall-db-trust-ip" {
#   value =  google_compute_instance.firewall.network_interface.3.network_ip
# }

# output "firewall-name" {
#   value = google_compute_instance.firewall.*.name
# }
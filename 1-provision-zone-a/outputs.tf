# output "backend_service" {
#   value = google_compute_region_backend_service.default[0].name
# }

# output "ilb_ip_address" {
#   description = "The internal IP assigned to the regional forwarding rule."
#   value       = google_compute_forwarding_rule.default[0].ip_address
# }

# output "regional_disk_self_link" {
#   value = google_compute_region_disk.regiondisk.self_link
# }
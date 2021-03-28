resource "google_compute_forwarding_rule" "default" {
  count                 = 1
  project               = var.project_id
  region                = var.region
  name                  = "int-fw-rule"
  load_balancing_scheme = "INTERNAL"
  ip_address            = null
  ip_protocol           = "TCP"
  all_ports             = true
  ports                 = []
  subnetwork            = "default"
  backend_service       = google_compute_region_backend_service.default[count.index].self_link
}

resource "google_compute_region_backend_service" "default" {
  count         = 1
  name          = "backend-svc"
  region        = var.region
  project       = var.project_id
  health_checks = [google_compute_health_check.default.self_link]
  network       = "default"

  backend {
    group = google_compute_instance_group.main[count.index].self_link
  }
}

resource "google_compute_instance_group" "main" {
  count       = 1
  name        = var.uig_name
  project     = var.project_id
  description = "Web servers instance group"
  zone        = "${var.region}-${var.zone_a}"

  instances = [
    google_compute_instance.main[count.index].self_link,
  ]

  named_port {
    name = "http"
    port = "80"
  }

  depends_on = [null_resource.attach_regional_disk, null_resource.force_attach_regional_disk]
}

resource "google_compute_health_check" "default" {
  provider = google-beta
  project  = var.project_id

  name = "hc-tcp"

  timeout_sec        = 1
  check_interval_sec = 1

  tcp_health_check {
    port = "80"
  }

  log_config {
    enable = true
  }
}

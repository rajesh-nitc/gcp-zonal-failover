locals {
  latest_snap_zo_a_split = split("-", var.latest_snapshot_zonal_disk_a)
  disk_zo_b_suffix       = element(local.latest_snap_zo_a_split, length(local.latest_snap_zo_a_split) - 1)
}

resource "google_compute_instance" "main" {
  count                     = 1
  name                      = var.instance_name
  zone                      = "${var.region}-${var.zone_b}"
  tags                      = []
  machine_type              = "n1-standard-1"
  allow_stopping_for_update = true

  boot_disk {
    initialize_params {
      image = "debian-cloud/debian-9"
    }
  }

  network_interface {
    network = "default"

    access_config {
    }
  }

  desired_status = var.bootstrap ? "RUNNING" : "TERMINATED"

  metadata_startup_script = templatefile("templates/startup-script.sh", {
    device_name_zonal  = var.device_name_zonal,
    device_name_region = var.device_name_region
  })

  lifecycle {
    ignore_changes = [attached_disk]
  }

}

resource "google_compute_attached_disk" "zonal_disk" {
  count       = var.bootstrap ? 0 : 1
  disk        = google_compute_disk.disk_from_latest_snapshot[count.index].id
  instance    = google_compute_instance.main[count.index].id
  device_name = var.device_name_zonal
}

resource "google_compute_instance_group" "main" {
  count       = 1
  name        = var.uig_name
  description = "Web servers instance group"
  zone        = "${var.region}-${var.zone_b}"

  instances = [
    google_compute_instance.main[count.index].self_link,
  ]

  named_port {
    name = "http"
    port = "80"
  }
}

resource "null_resource" "stop_vm" {
  count = var.bootstrap ? 1 : 0
  provisioner "local-exec" {
    command = <<EOT
    gcloud compute instances stop ${google_compute_instance.main[count.index].name} --zone=${var.region}-${var.zone_b} --project=${var.project_id}
    EOT
  }
}

resource "google_compute_resource_policy" "default" {
  project = var.project_id
  name    = "zone-b-pol"
  region  = var.region
  snapshot_schedule_policy {
    schedule {
      hourly_schedule {
        hours_in_cycle = 1
        start_time     = "11:00"
      }
    }
    retention_policy {
      max_retention_days    = 5
      on_source_disk_delete = "KEEP_AUTO_SNAPSHOTS"
    }
    snapshot_properties {
      storage_locations = ["us"]
      guest_flush       = false
    }
  }
}

resource "google_compute_disk_resource_policy_attachment" "default" {
  count   = var.bootstrap ? 0 : 1
  project = var.project_id
  name    = google_compute_resource_policy.default.name
  disk    = google_compute_disk.disk_from_latest_snapshot[count.index].name
  zone    = "${var.region}-${var.zone_b}"
}

resource "google_compute_disk" "disk_from_latest_snapshot" {
  count    = var.bootstrap ? 0 : 1
  name     = "${var.disk_zo_b}-${local.disk_zo_b_suffix}"
  type     = "pd-ssd"
  zone     = "${var.region}-${var.zone_b}"
  snapshot = var.latest_snapshot_zonal_disk_a
  size     = 10
}

resource "null_resource" "force_attach_regional_disk" {
  count = var.bootstrap ? 0 : 1
  triggers = {
    timestamp = timestamp()
  }
  provisioner "local-exec" {
    command = <<EOT
    gcloud compute instances attach-disk ${google_compute_instance.main[count.index].name} --project ${var.project_id} --zone ${var.region}-${var.zone_b} --disk ${var.disk_regional} --disk-scope regional --device-name ${var.device_name_region} --force-attach
    gcloud compute instances stop ${google_compute_instance.main[count.index].name} --zone=${var.region}-${var.zone_b} --project=${var.project_id}
    gcloud compute instances start ${google_compute_instance.main[count.index].name} --zone=${var.region}-${var.zone_b} --project=${var.project_id}
    EOT
  }
  depends_on = [google_compute_attached_disk.zonal_disk]
}

resource "null_resource" "attach_backend" {
  count = var.bootstrap ? 0 : 1
  triggers = {
    timestamp = timestamp()
  }
  provisioner "local-exec" {
    command = "gcloud compute backend-services add-backend ${var.backend_service} --instance-group=${google_compute_instance_group.main[count.index].name} --instance-group-zone=${var.region}-${var.zone_b} --project=${var.project_id} --region=${var.region}"
  }

  depends_on = [null_resource.force_attach_regional_disk]
}

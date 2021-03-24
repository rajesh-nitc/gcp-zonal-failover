resource "google_compute_instance" "main" {
  count                     = 1
  project                   = var.project_id
  name                      = var.instance_name
  zone                      = "${var.region}-${var.zone_a}"
  tags                      = []
  machine_type              = "n1-standard-1"
  allow_stopping_for_update = true

  attached_disk {
    source      = var.failback ? google_compute_disk.disk_from_latest_snapshot[count.index].self_link : google_compute_disk.zonaldisk[count.index].self_link
    device_name = var.device_name_zonal
    mode        = "READ_WRITE"

  }

  attached_disk {
    source      = google_compute_region_disk.regiondisk.self_link
    device_name = var.device_name_region
    mode        = "READ_WRITE"
  }

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

  desired_status = "RUNNING"

  metadata_startup_script = templatefile("templates/startup-script.sh", {
    device_name_zonal  = var.device_name_zonal,
    device_name_region = var.device_name_region
  })

  depends_on = [null_resource.detach_regional_disk]

}

resource "google_compute_region_disk" "regiondisk" {
  name                      = var.disk_regional
  type                      = "pd-ssd"
  region                    = var.region
  physical_block_size_bytes = 4096
  size                      = 10

  replica_zones = ["${var.region}-${var.zone_a}", "${var.region}-${var.zone_b}"]
}

resource "google_compute_disk" "zonaldisk" {
  count   = var.failback ? 0 : 1
  project = var.project_id
  name    = var.disk_zo_a
  zone    = "${var.region}-${var.zone_a}"
  type    = "pd-ssd"
  size    = 10
}

resource "google_compute_resource_policy" "default" {
  project = var.project_id
  name    = "zone-a-policy"
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
  count   = 1
  project = var.project_id
  name    = google_compute_resource_policy.default.name
  disk    = var.failback ? google_compute_disk.disk_from_latest_snapshot[count.index].name : google_compute_disk.zonaldisk[count.index].name
  zone    = "${var.region}-${var.zone_a}"
}


# Failback

resource "random_id" "random_hash_suffix" {
  count       = var.failback ? 1 : 0
  byte_length = 4
}

resource "google_compute_disk" "disk_from_latest_snapshot" {
  count    = var.failback ? 1 : 0
  name     = "${var.disk_zo_a}-${random_id.random_hash_suffix[count.index].hex}"
  type     = "pd-ssd"
  zone     = "${var.region}-${var.zone_a}"
  snapshot = var.latest_snapshot_zonal_disk_b
  size     = 10
}

resource "null_resource" "detach_regional_disk" {
  count = var.failback ? 0 : 1
  provisioner "local-exec" {
    command = "gcloud compute instances detach-disk ${var.instance_name_zo_b} --project ${var.project_id} --zone ${var.region}-${var.zone_b} --disk ${var.disk_regional} --disk-scope regional"
  }
}

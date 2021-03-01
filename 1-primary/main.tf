resource "google_compute_instance" "main" {
  name                      = "primary-instance"
  zone                      = "us-central1-a"
  tags                      = []
  machine_type              = "n1-standard-1"
  allow_stopping_for_update = true

  attached_disk {
    source      = google_compute_disk.zonaldisk.self_link
    device_name = var.device_name_zonal
    mode        = "READ_WRITE"

  }

  attached_disk {
    source      = google_compute_region_disk.regiondisk.self_link
    device_name = var.device_name_region
    mode        = "READ_WRITE"
  }

  scratch_disk {
    interface = "SCSI"
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

  metadata = {
    ssh-keys = "${var.gce_ssh_user}:${file(var.gce_ssh_pub_key_file)}"
  }

  metadata_startup_script = templatefile("templates/startup-script.sh", {
    device_name_zonal  = var.device_name_zonal,
    device_name_region = var.device_name_region
  })

}

resource "google_compute_disk" "zonaldisk" {
  name = "my-zonal-disk"
  zone = "us-central1-a"
  type = "pd-ssd"
  size = 10
}

resource "google_compute_region_disk" "regiondisk" {
  name                      = "my-region-disk"
  type                      = "pd-ssd"
  region                    = "us-central1"
  physical_block_size_bytes = 4096
  size                      = 10

  replica_zones = ["us-central1-a", "us-central1-b"]
}

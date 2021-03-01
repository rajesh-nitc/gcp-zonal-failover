resource "google_compute_disk" "failover_zonal_disk" {
  name  = "my-failover-zonal-disk"
  snapshot = "my-zonal-disk-snapshot"
  size  = 10
  type  = "pd-ssd"
  zone  = "us-central1-b"
}

resource "google_compute_instance" "main" {
  name                      = "failover-instance"
  zone                      = "us-central1-b"
  tags                      = []
  machine_type              = "n1-standard-1"
  allow_stopping_for_update = true

  attached_disk {
      source      = google_compute_disk.failover_zonal_disk.self_link
      device_name = var.device_name_zonal
      mode        = "READ_WRITE"

  }

  scratch_disk {
    interface = "SCSI"
  }

  boot_disk {
    initialize_params {
      image = var.base_image
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

  lifecycle {
    ignore_changes = [attached_disk]
  }

}

resource "null_resource" "provision_regional_disk" {
  connection {
    type        = "ssh"
    user        = var.gce_ssh_user
    private_key = file(var.gce_ssh_pri_key_file)
    host        = google_compute_instance.main.network_interface.0.access_config.0.nat_ip
  }

  # provisioner "local-exec" {
  #   command = "gcloud compute instances attach-disk ${google_compute_instance.main.name} --project ${var.project} --zone us-central1-b --disk ${var.disk_name_region} --disk-scope regional --device-name ${var.device_name_region} --force-attach"
  # }

  provisioner "file" {
      source      = "./templates/provision-regional-disk.sh"
      destination = "/tmp/provision-regional-disk.sh"
  }

  provisioner "remote-exec" {
      inline = [
        "chmod +x /tmp/provision-regional-disk.sh",
        "/tmp/provision-regional-disk.sh ${var.device_name_region}",
      ]
  }

  depends_on = [google_compute_instance.main]
}

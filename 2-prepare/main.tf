resource "null_resource" "update_fstab" {
  connection {
    type        = "ssh"
    user        = var.gce_ssh_user
    private_key = file(var.gce_ssh_pri_key_file)
    host        = var.host
  }

  provisioner "remote-exec" {
    inline = [
      "sudo sed -i '/google-region-data/d' /etc/fstab",
    ]
  }

  provisioner "local-exec" {
    command = "gcloud compute images create my-image1 --source-disk primary-instance --source-disk-zone us-central1-a --project ${var.project} --force"
  }

}

resource "google_compute_snapshot" "snap_zonal_disk" {
  name              = "my-zonal-disk-snapshot"
  source_disk       = var.disk_name_zonal
  zone              = "us-central1-a"
  storage_locations = ["us-central1"]
}

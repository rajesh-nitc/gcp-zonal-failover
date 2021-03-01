variable device_name_zonal {
  type    = string
  default = "zonal-data"
}

variable device_name_region {
  type    = string
  default = "region-data"
}

variable project {
  type    = string
  default = "ngfw1-301708"
}

variable disk_name_region {
  type    = string
  default = "my-region-disk"
}

variable base_image {
  type    = string
  default = "my-image"
}

variable "gce_ssh_user" {
  type    = string
  default = "terraform"
}

variable "gce_ssh_pub_key_file" {
  type    = string
  default = "~/.ssh/gcp-instance.pub"
}

variable "gce_ssh_pri_key_file" {
  type    = string
  default = "~/.ssh/gcp-instance"
}



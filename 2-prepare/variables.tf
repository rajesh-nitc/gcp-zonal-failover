variable disk_name_zonal {
  type        = string
  default     = "my-zonal-disk"
}

variable project {
  type        = string
  default     = "ngfw1-301708"
}

variable host {
  type        = string
  default     = "35.184.253.22"
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



variable "project_id" {
  type        = string
  description = "GCP Project id"
}

variable "region" {
  type = string
}

variable "zone_a" {
  type = string
}

variable "zone_b" {
  type = string
}

variable "device_name_zonal" {
  type    = string
  default = "zone-data"
}

variable "device_name_region" {
  type    = string
  default = "region-data"
}

variable "failback" {
  type    = bool
  default = false
}

variable "latest_snapshot_zonal_disk_b" {
  type        = string
  description = "Latest snapshot"
  default     = ""
}

variable "instance_name" {
  type = string
}

variable "disk_zo_a" {
  type = string
}

variable "disk_regional" {
  type = string
}

variable "uig_name" {
  type = string
}

variable "instance_name_zo_b" {
  type = string
}
variable "project_id" {
  type        = string
  description = "GCP Project id"
}

variable "failover" {
  type        = string
  description = "GCP Project id"
  default     = false
}

variable "latest_snapshot_zonal_disk_a" {
  type        = string
  description = "Latest snapshot"
  default     = ""
}

variable "backend_service" {
  type        = string
  description = "Latest snapshot"
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

variable "disk_zo_a" {
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

variable "instance_name" {
  type = string
}

variable "disk_zo_b" {
  type = string
}

variable "uig_name" {
  type = string
}

variable "instance_name_zo_a" {
  type = string
}

variable "disk_regional" {
  type = string
}

variable "regional_disk_self_link" {
  type = string
}

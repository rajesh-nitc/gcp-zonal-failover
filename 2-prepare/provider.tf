terraform {
  required_version = ">= 0.12"
}

provider "google" {
  project = var.project
}

provider "google-beta" {
  project = var.project
}

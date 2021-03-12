terraform {
  required_version = ">=0.12"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = ">= 3.39.0, <4.0.0"
    }

  }
}

provider "google" {
  project = var.project_id
}

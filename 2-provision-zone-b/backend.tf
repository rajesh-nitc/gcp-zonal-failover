terraform {
  required_version = ">=0.12"

  backend "gcs" {
    bucket = ""
    prefix = ""
  }
}
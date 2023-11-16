terraform {
  required_version = ">= 0.12"
}

provider "google" {
  credentials = file(var.credentials_file)

  project = var.project
  region = var.region
  zone = var.zone
}

locals {
  project = "shushutona"
  csv-bucket-name = "${local.project}-csv-bucket"
  function-source-bucket-name = "${local.project}-function-source-bucket"
}

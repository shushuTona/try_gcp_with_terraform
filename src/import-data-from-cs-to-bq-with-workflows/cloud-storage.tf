# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket
resource "google_storage_bucket" "csv-bucket" {
  name = "import-data-from-cs-to-bq-with-workflows-bucket"
  location = "ASIA"
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 30
    }
    action {
      type = "Delete"
    }
  }
}

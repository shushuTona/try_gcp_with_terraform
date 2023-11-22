# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/storage_bucket
resource "google_storage_bucket" "csv-bucket" {
  name = local.csv-bucket-name
  location = "ASIA"
  force_destroy = true

  lifecycle_rule {
    condition {
      age = 3
    }
    action {
      type = "Delete"
    }
  }
}

resource "google_storage_bucket" "function-source-bucket" {
  name     = local.function-source-bucket-name
  location = "ASIA"
}

data "archive_file" "function-src" {
  type = "zip"
  source_dir = "./file"
  output_path = "./function-source.zip"
}

resource "google_storage_bucket_object" "function-source-file" {
  name   = "function-source.${data.archive_file.function-src.output_md5}.zip"
  bucket = google_storage_bucket.function-source-bucket.name
  source = data.archive_file.function-src.output_path
}

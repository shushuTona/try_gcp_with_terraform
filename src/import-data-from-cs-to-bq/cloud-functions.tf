# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudfunctions2_function
resource "google_cloudfunctions2_function" "insert-csv-data-function" {
  name = "insert-csv-data-function"
  location = "asia-northeast1"

  build_config {
    runtime = "go121"
    entry_point = "cloudEventFunction"
    source {
      storage_source {
        bucket = google_storage_bucket.function-source-bucket.name
        object = google_storage_bucket_object.function-source-file.name
      }
    }
  }
}

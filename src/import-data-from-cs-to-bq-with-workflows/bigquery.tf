# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_dataset
resource "google_bigquery_dataset" "test-dataset" {
  dataset_id                  = "import_data_from_cs_to_bq_with_workflows"
  location                    = "asia-northeast1"
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_table
resource "google_bigquery_table" "test-table" {
  dataset_id = google_bigquery_dataset.test-dataset.dataset_id
  table_id   = "test_table"

  time_partitioning {
    field = "created_at"
    type = "DAY"
  }

  schema = file("${path.module}/schema.json")
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/bigquery_table
resource "google_bigquery_dataset" "test_dataset" {
  dataset_id = "test_dataset"
  description = "test dataset"
  location = "asia-northeast1"
  default_table_expiration_ms = 3600000

  labels = {
    env = "labels"
  }
}

resource "google_bigquery_table" "test_table" {
  dataset_id = google_bigquery_dataset.test_dataset.dataset_id
  table_id = "test_table"

  time_partitioning {
    type = "DAY"
  }

  labels = {
    env = "labels"
  }

  schema = <<EOF
[
    {
        "name": "id",
        "type": "INTEGER",
        "mode": "REQUIRED"
    },
    {
        "name": "name",
        "type": "STRING",
        "mode": "NULLABLE"
    }
]
EOF

}

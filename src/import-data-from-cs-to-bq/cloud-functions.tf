# https://cloud.google.com/functions/docs/calling/storage?hl=ja

data "google_storage_project_service_account" "default" {
}

data "google_project" "project" {
}

resource "google_project_iam_member" "gcs_pubsub_publishing" {
  project = data.google_project.project.project_id
  role    = "roles/pubsub.publisher"
  member  = "serviceAccount:${data.google_storage_project_service_account.default.email_address}"
}

resource "google_service_account" "account" {
  account_id   = "gcf-sa"
  display_name = "Test Service Account - used for both the cloud function and eventarc trigger in the test"
}

resource "google_project_iam_member" "invoking" {
  project    = data.google_project.project.project_id
  role       = "roles/run.invoker"
  member     = "serviceAccount:${google_service_account.account.email}"
  depends_on = [google_project_iam_member.gcs_pubsub_publishing]
}

resource "google_project_iam_member" "event_receiving" {
  project    = data.google_project.project.project_id
  role       = "roles/eventarc.eventReceiver"
  member     = "serviceAccount:${google_service_account.account.email}"
  depends_on = [google_project_iam_member.invoking]
}

resource "google_project_iam_member" "artifactregistry_reader" {
  project    = data.google_project.project.project_id
  role       = "roles/artifactregistry.reader"
  member     = "serviceAccount:${google_service_account.account.email}"
  depends_on = [google_project_iam_member.event_receiving]
}

# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/cloudfunctions2_function
resource "google_cloudfunctions2_function" "insert-csv-data-function" {
  depends_on = [
    google_project_iam_member.event_receiving,
    google_project_iam_member.artifactregistry_reader,
  ]

  name = "insert-csv-data-function"
  location = "asia-northeast1"

  description = "function to add data to BigQuery based on CSV file added to Cloud Storage"

  build_config {
    runtime = "go121"
    entry_point = "cloudEventFunction"

    environment_variables = {
      TEST_ENV = "test-env"
    }

    source {
      storage_source {
        bucket = google_storage_bucket.function-source-bucket.name
        object = google_storage_bucket_object.function-source-file.name
      }
    }
  }

  service_config {
    # max_instance_count = 3
    # min_instance_count = 1
    # available_memory   = "256M"
    # timeout_seconds    = 60
    # environment_variables = {
    #   SERVICE_CONFIG_TEST = "config_test"
    # }
    ingress_settings               = "ALLOW_INTERNAL_ONLY"
    # all_traffic_on_latest_revision = true
    service_account_email          = google_service_account.account.email
  }

  event_trigger {
    trigger_region        = "asia"
    event_type            = "google.cloud.storage.object.v1.finalized"
    retry_policy          = "RETRY_POLICY_RETRY"
    service_account_email = google_service_account.account.email

    event_filters {
      attribute = "bucket"
      value = google_storage_bucket.csv-bucket.name
    }
  }
}

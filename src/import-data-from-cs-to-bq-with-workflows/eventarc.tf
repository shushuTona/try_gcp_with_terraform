# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/eventarc_trigger
resource "google_eventarc_trigger" "event-trigger" {
  name     = "workflows-trriger-by-cs"
  location = "asia"
  # location = "asia-northeast1"

  matching_criteria {
    attribute = "type"
    value     = "google.cloud.storage.object.v1.finalized"
  }

  matching_criteria {
    attribute = "bucket"
    value     = google_storage_bucket.csv-bucket.name
  }

  destination {
    workflow = google_workflows_workflow.test-workflow.id
  }

  service_account = google_service_account.account.id
}

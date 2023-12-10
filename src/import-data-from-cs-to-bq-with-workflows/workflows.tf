# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/workflows_workflow
resource "google_workflows_workflow" "test-workflow" {
  name            = "workflow"
  region          = "asia-northeast1"
  description     = "workflow for importing csv file data to bq"
  service_account = google_service_account.account.id

  # https://cloud.google.com/workflows/docs/reference/syntax
  # https://cloud.google.com/workflows/docs/reference/googleapis/bigquery/v2/jobs/insert
  # https://cloud.google.com/workflows/docs/reference/googleapis/bigquery/v2/jobs/query
  source_contents = templatefile("${path.module}/workflow.tftpl", {
    projectId = var.project,
    schema = file("${path.module}/schema.json"),
    query = file("${path.module}/query/query.sql")
  })
}

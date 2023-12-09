# https://registry.terraform.io/providers/hashicorp/google/latest/docs/resources/workflows_workflow
resource "google_workflows_workflow" "test-workflow" {
  name            = "workflow"
  region          = "asia-northeast1"
  description     = "workflow for importing csv file data to bq"
  service_account = google_service_account.account.id

  # https://cloud.google.com/workflows/docs/reference/syntax
  source_contents = templatefile("${path.module}/workflow.tftpl", { schema = file("${path.module}/schema.json"), projectId = var.project })
}

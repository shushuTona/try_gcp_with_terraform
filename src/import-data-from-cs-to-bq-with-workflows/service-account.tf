data "google_project" "project" {
}

resource "google_service_account" "account" {
  account_id   = "with-workflowsf-sa"
  display_name = "service account used importing data to bq with workflows"
}

resource "google_project_iam_member" "workflowsinvoker" {
  project = data.google_project.project.project_id
  role    = "roles/workflows.invoker"
  member  = "serviceAccount:${google_service_account.account.email}"
}

resource "google_project_iam_member" "eventReceiver" {
  project = data.google_project.project.project_id
  role    = "roles/eventarc.eventReceiver"
  member  = "serviceAccount:${google_service_account.account.email}"
}

resource "google_project_iam_member" "logWriter" {
  project = data.google_project.project.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.account.email}"
}

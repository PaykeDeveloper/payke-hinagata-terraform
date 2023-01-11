resource "google_service_account" "cloud_run" {
  account_id = var.cloud_run_account_id
}

resource "google_service_account" "github_actions" {
  account_id = var.github_actions_account_id
}

resource "google_service_account_iam_member" "github_actions" {
  service_account_id = google_service_account.cloud_run.name
  role               = "roles/iam.serviceAccountUser"
  member             = "serviceAccount:${google_service_account.github_actions.email}"
}

resource "google_project_iam_member" "github_actions" {
  project = var.project
  role    = "roles/run.developer"
  member  = "serviceAccount:${google_service_account.github_actions.email}"
}

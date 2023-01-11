output "cloud_run_email" {
  value = google_service_account.cloud_run.email
}

output "github_actions_email" {
  value = google_service_account.github_actions.email
}

output "github_actions_name" {
  value = google_service_account.github_actions.name
}

output "repository_host" {
  value       = local.repository_host
  description = "Register as GCP_REPOSITORY_HOST in the github actions secret."
}

output "repository_path" {
  value       = local.repository_path
  description = "Register as GCP_REPOSITORY_PATH in the github actions secret."
}

output "service_account" {
  value       = module.service_account.github_actions_email
  description = "Register as GCP_SERVICE_ACCOUNT in the github actions secret."
}

output "workload_identity_provider" {
  value       = module.workload_identity.provider_name
  description = "Register as GCP_IDENTITY_PROVIDER in the github actions secret."
}

output "cloud_run" {
  value       = module.cloud_run.name
  description = "Register as GCP_CROUD_RUN in the github actions secret."
}

output "url" {
  value       = module.cloud_run.url
  description = "You can access the API at this URL."
}


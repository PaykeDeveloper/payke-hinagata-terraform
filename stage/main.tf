provider "google" {
  region  = var.location
  project = var.project
}

terraform {
  backend "gcs" {
    prefix = "terraform/state"
  }
}

module "project_service" {
  source = "../modules/project-service"
}

module "service_account" {
  depends_on                = [module.project_service]
  source                    = "../modules/service-account"
  project                   = var.project
  cloud_run_account_id      = var.cloud_run_account_id
  github_actions_account_id = var.github_actions_account_id
}

locals {
  github_actions_member = "serviceAccount:${module.service_account.github_actions_email}"
  cloud_run_member      = "serviceAccount:${module.service_account.cloud_run_email}"
}

module "artifact_registry" {
  depends_on    = [module.project_service]
  source        = "../modules/artifact-registry"
  location      = var.location
  repository_id = var.repository_id
  members       = [local.github_actions_member]
}

module "workload_identity" {
  depends_on         = [module.artifact_registry]
  source             = "../modules/workload-identity"
  service_account_id = module.service_account.github_actions_name
  github_repository  = var.github_repository
}

module "secret_manager" {
  depends_on = [module.project_service]
  source     = "../modules/secret-manager"
  creation   = var.creation
  members    = [local.cloud_run_member]
}

locals {
  repository_host = "${var.location}-docker.pkg.dev"
  repository_path = "/${module.artifact_registry.project}/${module.artifact_registry.name}/backend"
}

module "cloud_run" {
  depends_on           = [module.artifact_registry, module.secret_manager]
  source               = "../modules/cloud-run"
  location             = var.location
  name                 = var.cloud_run_name
  image                = coalesce(var.cloud_run_image, "${local.repository_host}${local.repository_path}")
  service_account_name = module.service_account.cloud_run_email
  secret_name          = module.secret_manager.secret_id
  domain_name          = var.domain_name
  creation             = var.creation
}

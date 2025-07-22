/**
 * Copyright 2024 Google LLC
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

locals {
  per_module_services = {
    backup = [
      "sqladmin.googleapis.com",
      "serviceusage.googleapis.com",
    ]
    mssql = [
      "sqladmin.googleapis.com",
      "serviceusage.googleapis.com",
    ]
    mysql = [
      "sqladmin.googleapis.com",
      "serviceusage.googleapis.com",
    ]
    postgresql = [
      "sqladmin.googleapis.com",
      "serviceusage.googleapis.com",
    ]
    private_service_access = [
      "servicenetworking.googleapis.com",
      "serviceusage.googleapis.com",
    ]
    restore = [
      "sqladmin.googleapis.com",
      "serviceusage.googleapis.com",
    ]
    safer_mysql = [
      "sqladmin.googleapis.com",
      "serviceusage.googleapis.com",
    ]
    root = [
      "sqladmin.googleapis.com",
      "serviceusage.googleapis.com",
      "iam.googleapis.com",
      "cloudresourcemanager.googleapis.com",
    ]
  }
}

module "project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 18.0"

  name              = "ci-sql-db"
  random_project_id = "true"
  org_id            = var.org_id
  folder_id         = google_folder.autokey_folder.folder_id
  billing_account   = var.billing_account
  deletion_policy   = "DELETE"

  activate_apis = concat([
    "cloudkms.googleapis.com",
    "cloudscheduler.googleapis.com",
    "compute.googleapis.com",
    "monitoring.googleapis.com",
    "workflows.googleapis.com",
  ], flatten(values(local.per_module_services)))
}

resource "google_service_account" "cloudsql_pg_sa" {
  project    = module.project.project_id
  account_id = "cloudsql-pg-sa-01"
}

resource "google_service_account" "cloudsql_mysql_sa" {
  project    = module.project.project_id
  account_id = "cloudsql-mysql-sa-01"
}

resource "google_project_service_identity" "workflos_sa" {
  provider = google-beta
  project  = module.project.project_id
  service  = "workflows.googleapis.com"
}

resource "random_id" "suffix" {
  byte_length = 4
}

resource "google_folder" "autokey_folder" {
  provider            = google-beta
  display_name        = "ci-sql-db-folder-${random_id.suffix.hex}"
  parent              = "folders/${var.folder_id}"
  deletion_protection = false
}

module "autokey-project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 18.0"

  name              = "ci-sql-db-autokey"
  random_project_id = "true"
  org_id            = var.org_id
  folder_id         = google_folder.autokey_folder.folder_id
  billing_account   = var.billing_account
  deletion_policy   = "DELETE"

  activate_apis = [
    "cloudkms.googleapis.com",
  ]
}

resource "time_sleep" "wait_enable_service_api" {
  depends_on      = [module.autokey-project]
  create_duration = "30s"
}

resource "google_project_service_identity" "kms_service_agent" {
  provider   = google-beta
  service    = "cloudkms.googleapis.com"
  project    = module.autokey-project.project_id
  depends_on = [time_sleep.wait_enable_service_api]
}

resource "time_sleep" "wait_service_agent" {
  depends_on      = [google_project_service_identity.kms_service_agent]
  create_duration = "10s"
}

resource "google_project_iam_member" "autokey_project_admin" {
  provider   = google-beta
  project    = module.autokey-project.project_id
  role       = "roles/cloudkms.admin"
  member     = "serviceAccount:service-${module.autokey-project.project_number}@gcp-sa-cloudkms.iam.gserviceaccount.com"
  depends_on = [time_sleep.wait_service_agent]
}

resource "time_sleep" "wait_srv_acc_permissions" {
  create_duration = "10s"
  depends_on      = [google_project_iam_member.autokey_project_admin]
}

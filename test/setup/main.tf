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

module "project" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 18.0"

  name              = "ci-sql-db"
  random_project_id = "true"
  org_id            = var.org_id
  folder_id         = google_folder.autokey_folder.folder_id
  billing_account   = var.billing_account
  deletion_policy   = "DELETE"

  activate_apis = [
    "cloudkms.googleapis.com",
    "cloudresourcemanager.googleapis.com",
    "cloudscheduler.googleapis.com",
    "compute.googleapis.com",
    "iam.googleapis.com",
    "monitoring.googleapis.com",
    "servicenetworking.googleapis.com",
    "serviceusage.googleapis.com",
    "sqladmin.googleapis.com",
    "workflows.googleapis.com",
  ]
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

resource "google_folder" "autokey_folder" {
  provider            = google-beta
  display_name        = "ci-sql-db-folder"
  parent              = "folders/${var.folder_id}"
  deletion_protection = false
}

# Using same project for autokey, not ideal but should be fine for testing
module "autokey" {
  source                         = "GoogleCloudPlatform/autokey/google"
  version                        = "1.1.1"
  billing_account                = var.billing_account
  organization_id                = var.org_id
  create_new_folder              = false
  folder_id                      = google_folder.autokey_folder.folder_id
  create_new_autokey_key_project = true
  autokey_key_project_name       = "ci-sql-db-autokey"
  autokey_key_project_id         = ""
  parent_folder_id               = ""
  autokey_folder_users           = [google_service_account.int_test.member]
  autokey_project_kms_admins     = [google_service_account.int_test.member]
  autokey_folder_admins          = [google_service_account.int_test.member]
}

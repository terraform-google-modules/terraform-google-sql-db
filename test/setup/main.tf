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
  version = "~> 17.0"

  name              = "ci-sql-db"
  random_project_id = "true"
  org_id            = var.org_id
  folder_id         = var.folder_id
  billing_account   = var.billing_account

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

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
  per_module_roles = {
    backup = [
      "roles/cloudsql.admin",
      "roles/iam.serviceAccountUser",
      "roles/logging.logWriter",
    ]
    mssql = [
      "roles/cloudsql.admin",
      "roles/iam.serviceAccountUser",
      "roles/logging.logWriter",
    ]
    mysql = [
      "roles/cloudsql.admin",
      "roles/iam.serviceAccountUser",
      "roles/logging.logWriter",
    ]
    postgresql = [
      "roles/cloudsql.admin",
      "roles/iam.serviceAccountUser",
      "roles/logging.logWriter",
    ]
    private_service_access = [
      "roles/servicenetworking.networksAdmin",
      "roles/iam.serviceAccountUser",
    ]
    restore = [
      "roles/cloudsql.admin",
      "roles/iam.serviceAccountUser",
      "roles/logging.logWriter",
    ]
    safer_mysql = [
      "roles/cloudsql.admin",
      "roles/iam.serviceAccountUser",
      "roles/logging.logWriter",
    ]
    root = [
      "roles/resourcemanager.projectIamAdmin",
      "roles/serviceusage.serviceUsageAdmin",
      "roles/cloudsql.admin",
      "roles/iam.serviceAccountAdmin",
      "roles/iam.serviceAccountUser",
    ]
  }

  int_required_roles = concat([
    "roles/cloudkms.admin",
    "roles/cloudkms.autokeyAdmin",
    "roles/cloudkms.cryptoKeyEncrypterDecrypter",
    "roles/cloudscheduler.admin",
    "roles/compute.admin",
    "roles/compute.networkAdmin",
    "roles/monitoring.editor",
    "roles/storage.admin",
    "roles/workflows.admin",
  ], flatten(values(local.per_module_roles)))
}

resource "google_service_account" "int_test" {
  project      = module.project.project_id
  account_id   = "ci-account"
  display_name = "ci-account"
}

resource "google_project_iam_member" "int_test" {
  count = length(local.int_required_roles)

  project = module.project.project_id
  role    = local.int_required_roles[count.index]
  member  = "serviceAccount:${google_service_account.int_test.email}"
}

resource "google_folder_iam_member" "int_test" {
  count = length(local.int_required_roles)

  folder = google_folder.autokey_folder.folder_id
  role   = local.int_required_roles[count.index]
  member = "serviceAccount:${google_service_account.int_test.email}"
}


resource "google_service_account_key" "int_test" {
  service_account_id = google_service_account.int_test.id
}

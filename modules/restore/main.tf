/**
 * Copyright 2022 Google LLC
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
  create_service_account = var.service_account == null || var.service_account == "" ? true : false
  service_account        = local.create_service_account ? google_service_account.sql_import_serviceaccount[0].email : var.service_account
}


################################
#                              #
#   Service Account and IAM    #
#                              #
################################
resource "google_service_account" "sql_import_serviceaccount" {
  count        = local.create_service_account ? 1 : 0
  account_id   = trimsuffix(substr("import-${var.sql_instance}", 0, 28), "-")
  display_name = "Managed by Terraform - Service account for import of SQL Instance ${var.sql_instance}"
  project      = var.project_id
}

resource "google_project_iam_member" "sql_import_serviceaccount_sql_admin" {
  count   = local.create_service_account ? 1 : 0
  member  = "serviceAccount:${google_service_account.sql_import_serviceaccount[0].email}"
  role    = "roles/cloudsql.admin"
  project = var.project_id
}

resource "google_project_iam_member" "sql_import_serviceaccount_workflow_invoker" {
  count   = local.create_service_account ? 1 : 0
  member  = "serviceAccount:${google_service_account.sql_import_serviceaccount[0].email}"
  role    = "roles/workflows.invoker"
  project = var.project_id
}

data "google_sql_database_instance" "import_instance" {
  name    = var.sql_instance
  project = var.project_id
}

################################
#                              #
#       Import Workflow        #
#                              #
################################
resource "google_workflows_workflow" "sql_import" {
  name            = "sql-import-${var.sql_instance}"
  region          = var.region
  description     = "Workflow for importing the CloudSQL Instance database using an external import"
  project         = var.project_id
  service_account = local.service_account
  source_contents = templatefile("${path.module}/templates/import.yaml.tftpl", {
    project          = var.project_id
    instanceName     = var.sql_instance
    databases        = jsonencode(var.import_databases)
    gcsBucket        = var.import_uri
    exportedInstance = split("/", var.import_uri)[3]
    dbType           = split("_", data.google_sql_database_instance.import_instance.database_version)[0]
  })
}

resource "google_storage_bucket_iam_member" "sql_instance_account" {
  bucket = split("/", var.import_uri)[2] #Get the name of the bucket out of the URI
  member = "serviceAccount:${data.google_sql_database_instance.import_instance.service_account_email_address}"
  role   = "roles/storage.objectViewer"
}

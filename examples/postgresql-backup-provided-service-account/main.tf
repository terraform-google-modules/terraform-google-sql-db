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

module "postgresql" {
  source  = "terraform-google-modules/sql-db/google//modules/postgresql"
  version = "~> 21.0"

  name                 = "example-postgres"
  random_instance_name = true
  database_version     = "POSTGRES_9_6"
  project_id           = var.project_id
  zone                 = "us-central1-a"
  region               = "us-central1"
  tier                 = "db-custom-1-3840"

  deletion_protection = false

  ip_configuration = {
    ipv4_enabled        = true
    private_network     = null
    require_ssl         = true
    allocated_ip_range  = null
    authorized_networks = []
  }
}

resource "google_storage_bucket" "backup" {
  name     = "${module.postgresql.instance_name}-backup"
  location = "us-central1"
  # TODO: don't use force_destroy for production this is just required for testing
  force_destroy = true
  project       = var.project_id
}

resource "google_monitoring_notification_channel" "email" {
  display_name = "Test email notification channel"
  type         = "email"
  project      = var.project_id
  labels = {
    email_address = "test@acme.com"
  }
}

module "backup" {
  source  = "terraform-google-modules/sql-db/google//modules/backup"
  version = "~> 21.0"

  region                      = "us-central1"
  project_id                  = var.project_id
  sql_instance                = module.postgresql.instance_name
  export_databases            = []
  export_uri                  = google_storage_bucket.backup.url
  backup_retention_time       = 1
  backup_schedule             = "5 * * * *"
  export_schedule             = "10 * * * *"
  use_serverless_export       = true
  service_account             = "${data.google_project.test_project.number}-compute@developer.gserviceaccount.com"
  create_notification_channel = false
  notification_channels       = [google_monitoring_notification_channel.email.id]
}

data "google_project" "test_project" {
  project_id = var.project_id
}

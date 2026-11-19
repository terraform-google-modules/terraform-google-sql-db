/**
 * Copyright 2026 Google LLC
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


module "postgresql-db" {
  source  = "terraform-google-modules/sql-db/google//modules/postgresql"
  version = "~> 28.0"

  name                 = var.db_name
  random_instance_name = true
  database_version     = "POSTGRES_16"
  project_id           = var.project_id
  zone                 = "us-east1-d"
  region               = "us-east1"

  disk_autoresize_limit = 20

  deletion_protection = false

  alerts = {
    notification_channels = [google_monitoring_notification_channel.email.id]
  }
}

resource "google_monitoring_notification_channel" "email" {
  display_name = "Test email notification channel"
  type         = "email"
  project      = var.project_id
  labels = {
    email_address = var.test_email
  }
}

/**
 * Copyright 2018 Google LLC
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
  default_user_host = "%"
}

resource "google_sql_database_instance" "default" {
  project          = "${var.project_id}"
  name             = "${var.name}"
  database_version = "${var.database_version}"
  region           = "${var.region}"

  settings {
    tier                        = "${var.tier}"
    activation_policy           = "${var.activation_policy}"
    authorized_gae_applications = ["${var.authorized_gae_applications}"]
    backup_configuration        = ["${var.backup_configuration}"]
    ip_configuration            = ["${var.ip_configuration}"]

    disk_autoresize = "${var.disk_autoresize}"

    disk_size      = "${var.disk_size}"
    disk_type      = "${var.disk_type}"
    pricing_plan   = "${var.pricing_plan}"
    user_labels    = "${var.user_labels}"
    database_flags = ["${var.database_flags}"]

    location_preference {
      zone = "${var.region}-${var.zone}"
    }

    maintenance_window {
      day          = "${var.maintenance_window_day}"
      hour         = "${var.maintenance_window_hour}"
      update_track = "${var.maintenance_window_update_track}"
    }
  }

  lifecycle {
    ignore_changes = ["disk_size"]
  }
}

resource "google_sql_database" "databases" {
  count      = "${length(var.databases)}"
  project    = "${var.project_id}"
  name       = "${lookup(var.databases[count.index], "name")}"
  charset    = "${lookup(var.databases[count.index], "charset", "utf8mb4")}"
  collation  = "${lookup(var.databases[count.index], "collation", "utf8mb4_general_ci")}"
  instance   = "${google_sql_database_instance.default.name}"
  depends_on = ["google_sql_database_instance.default"]
}

resource "random_id" "user-password" {
  keepers = {
    name = "${google_sql_database_instance.default.name}"
  }

  byte_length = 8
  depends_on  = ["google_sql_database_instance.default"]
}

resource "google_sql_user" "users" {
  count      = "${length(var.users)}"
  project    = "${var.project_id}"
  instance   = "${google_sql_database_instance.default.name}"
  name       = "${lookup(var.users[count.index], "name")}"
  password   = "${lookup(var.users[count.index], "password", random_id.user-password.hex)}"
  host       = "${lookup(var.users[count.index], "host", local.default_user_host)}"
  depends_on = ["google_sql_database_instance.default"]
}

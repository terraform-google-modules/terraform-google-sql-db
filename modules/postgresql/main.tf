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
  ip_configuration_enabled = "${length(keys(var.ip_configuration)) > 0 ? true : false}"

  ip_configurations = {
    enabled  = "${var.ip_configuration}"
    disabled = "${map()}"
  }
}

resource "google_sql_database_instance" "default" {
  project          = "${var.project_id}"
  name             = "${var.name}"
  database_version = "${var.database_version}"
  region           = "${var.region}"

  settings {
    tier                        = "${var.tier}"
    activation_policy           = "${var.activation_policy}"
    availability_type           = "${var.availability_type}"
    authorized_gae_applications = ["${var.authorized_gae_applications}"]
    backup_configuration        = ["${var.backup_configuration}"]
    ip_configuration            = ["${local.ip_configurations["${local.ip_configuration_enabled ? "enabled" : "disabled"}"]}"]

    disk_autoresize = "${var.disk_autoresize}"
    disk_size       = "${var.disk_size}"
    disk_type       = "${var.disk_type}"
    pricing_plan    = "${var.pricing_plan}"
    user_labels     = "${var.user_labels}"
    database_flags  = ["${var.database_flags}"]

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

  timeouts {
    create = "${var.create_timeout}"
    update = "${var.update_timeout}"
    delete = "${var.delete_timeout}"
  }
}

resource "google_sql_database" "default" {
  name       = "${var.db_name}"
  project    = "${var.project_id}"
  instance   = "${google_sql_database_instance.default.name}"
  charset    = "${var.db_charset}"
  collation  = "${var.db_collation}"
  depends_on = ["google_sql_database_instance.default"]
}

resource "google_sql_database" "additional_databases" {
  count      = "${length(var.additional_databases)}"
  project    = "${var.project_id}"
  name       = "${lookup(var.additional_databases[count.index], "name")}"
  charset    = "${lookup(var.additional_databases[count.index], "charset", "")}"
  collation  = "${lookup(var.additional_databases[count.index], "collation", "")}"
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

resource "google_sql_user" "default" {
  name       = "${var.user_name}"
  project    = "${var.project_id}"
  instance   = "${google_sql_database_instance.default.name}"
  password   = "${var.user_password == "" ? random_id.user-password.hex : var.user_password}"
  depends_on = ["google_sql_database_instance.default"]
}

resource "google_sql_user" "additional_users" {
  count      = "${length(var.additional_users)}"
  project    = "${var.project_id}"
  name       = "${lookup(var.additional_users[count.index], "name")}"
  password   = "${lookup(var.additional_users[count.index], "password", random_id.user-password.hex)}"
  instance   = "${google_sql_database_instance.default.name}"
  depends_on = ["google_sql_database_instance.default"]
}

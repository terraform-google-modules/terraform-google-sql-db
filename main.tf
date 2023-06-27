/*
 * Copyright 2017 Google Inc.
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *   http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

resource "google_sql_database_instance" "default" {
  name                 = "${var.name}"
  project              = "${var.project}"
  region               = "${var.region}"
  database_version     = "${var.database_version}"
  master_instance_name = "${var.master_instance_name}"

  lifecycle {
    ignore_changes = [settings.0.disk_size]
  }

  settings {
    tier                        = "${var.tier}"
    activation_policy           = "${var.activation_policy}"
    authorized_gae_applications = var.authorized_gae_applications
    disk_autoresize             = "${var.disk_autoresize}"
    disk_size                   = "${var.disk_size}"
    disk_type                   = "${var.disk_type}"
    pricing_plan                = "${var.pricing_plan}"
    replication_type            = "${var.replication_type}"

    dynamic "database_flags" {
      for_each = var.database_flags
      content {
        name  = database_flags.value["name"]
        value = database_flags.value["value"]
      }
    }

    dynamic "maintenance_window" {
      for_each = var.maintenance_window
      content {
        day          = maintenance_window.value["day"]
        hour         = maintenance_window.value["hour"]
        update_track = maintenance_window.value["update_track"]
      }
    }

    dynamic "location_preference" {
      for_each = var.location_preference
      content {
        follow_gae_application = location_preference.value["follow_gae_application"]
        zone                   = location_preference.value["zone"]
      }
    }

    dynamic "ip_configuration" {
      for_each = var.ip_configuration
      content {
        ipv4_enabled    = ip_configuration.value["ipv4_enabled"]
        private_network = ip_configuration.value["private_network"]
        require_ssl     = ip_configuration.value["require_ssl"]
      }
    }

    dynamic "backup_configuration" {
      for_each = var.backup_configuration ? [] : [1]
      content {
        binary_log_enabled = var.backup_configuration["binary_log_enabled"]
        enabled = var.backup_configuration["enabled"]
        start_time = var.backup_configuration["start_time"]
      }
    }
  }
}

resource "google_sql_database" "default" {
  count     = "${var.master_instance_name == "" ? 1 : 0}"
  name      = "${var.db_name}"
  project   = "${var.project}"
  instance  = "${google_sql_database_instance.default.name}"
  charset   = "${var.db_charset}"
  collation = "${var.db_collation}"
}

resource "random_id" "user-password" {
  byte_length = 8
}

resource "google_sql_user" "default" {
  count    = "${var.master_instance_name == "" ? 1 : 0}"
  name     = "${var.user_name}"
  project  = "${var.project}"
  instance = "${google_sql_database_instance.default.name}"
  host     = "${var.user_host}"
  password = "${var.user_password == "" ? random_id.user-password.hex : var.user_password}"
}

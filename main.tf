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

  settings {
    tier                        = "${var.tier}"
    activation_policy           = "${var.activation_policy}"
    authorized_gae_applications = ["${var.authorized_gae_applications}"]
    disk_autoresize             = "${var.disk_autoresize}"
    backup_configuration        = ["${var.backup_configuration}"]
    ip_configuration            = ["${var.ip_configuration}"]
    location_preference         = ["${var.location_preference}"]
    disk_size                   = "${var.disk_size}"
    disk_type                   = "${var.disk_type}"
    pricing_plan                = "${var.pricing_plan}"
    user_labels                 = var.labels

    dynamic database_flags {
      for_each = var.database_flags
      content {
        name  = database_flags.value["name"]
        value = database_flags.value["value"]
      }
    }

    dynamic maintenance_window {
      for_each = var.maintenance_window
      content = {
        day  = maintenance_window.value["day"]
        hour = maintenance_window.value["hour"]
      }
    }
  }

  dynamic replica_configuration {
    for_each = var.replica_configuration
    content {
      ca_certificate            = try(replica_configuration.value["ca_certificate"], null)
      client_certificate        = try(replica_configuration.value["client_certificate"], null)
      client_key                = try(replica_configuration.value["client_key"], null)
      connect_retry_interval    = try(replica_configuration.value["connect_retry_interval"], null)
      dump_file_path            = try(replica_configuration.value["dump_file_path"], null)
      failover_target           = try(replica_configuration.value["failover_target"], null)
      master_heartbeat_period   = try(replica_configuration.value["master_heartbeat_period"], null)
      password                  = try(replica_configuration.value["password"], null)
      ssl_cipher                = try(replica_configuration.value["ssl_cipher"], null)
      username                  = try(replica_configuration.value["username"], null)
      verify_server_certificate = try(replica_configuration.value["verify_server_certificate"], null)
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

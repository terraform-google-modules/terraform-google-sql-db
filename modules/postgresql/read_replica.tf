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
  primary_zone       = "${var.zone}"
  read_replica_zones = ["${compact(split(",", var.read_replica_zones))}"]

  zone_mapping = {
    enabled  = ["${local.read_replica_zones}"]
    disabled = "${list(local.primary_zone)}"
  }

  zones_enabled = "${length(local.read_replica_zones) > 0}"
  mod_by        = "${local.zones_enabled ? length(local.read_replica_zones) : 1}"

  zones = "${local.zone_mapping["${local.zones_enabled ? "enabled" : "disabled"}"]}"
}

resource "google_sql_database_instance" "replicas" {
  count                 = "${var.read_replica_size}"
  project               = "${var.project_id}"
  name                  = "${var.name}-replica${count.index}"
  database_version      = "${var.database_version}"
  region                = "${var.region}"
  master_instance_name  = "${google_sql_database_instance.default.name}"
  replica_configuration = ["${merge(var.read_replica_configuration, map("failover_target", false))}"]

  settings {
    tier                        = "${var.read_replica_tier}"
    activation_policy           = "${var.read_replica_activation_policy}"
    authorized_gae_applications = ["${var.authorized_gae_applications}"]
    availability_type           = "${var.read_replica_availability_type}"
    ip_configuration            = ["${local.ip_configurations["${local.ip_configuration_enabled ? "enabled" : "disabled"}"]}"]

    crash_safe_replication = "${var.read_replica_crash_safe_replication}"
    disk_autoresize        = "${var.read_replica_disk_autoresize}"
    disk_size              = "${var.read_replica_disk_size}"
    disk_type              = "${var.read_replica_disk_type}"
    pricing_plan           = "${var.read_replica_pricing_plan}"
    replication_type       = "${var.read_replica_replication_type}"
    user_labels            = "${var.read_replica_user_labels}"
    database_flags         = ["${var.read_replica_database_flags}"]

    location_preference {
      zone = "${length(local.zones) == 0 ? "" : "${var.region}-${local.zones[count.index % local.mod_by]}"}"
    }

    maintenance_window {
      day          = "${var.read_replica_maintenance_window_day}"
      hour         = "${var.read_replica_maintenance_window_hour}"
      update_track = "${var.read_replica_maintenance_window_update_track}"
    }
  }

  depends_on = ["google_sql_database_instance.default"]

  lifecycle {
    ignore_changes = ["disk_size"]
  }

  timeouts {
    create = "${var.create_timeout}"
    update = "${var.update_timeout}"
    delete = "${var.delete_timeout}"
  }
}

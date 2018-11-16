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
  default_tier                            = "db-n1-standard-1"
  default_activation_policy               = "ALWAYS"           // ON_DEMAND
  default_crash_safe_replication          = true
  default_disk_autoresize                 = true
  default_disk_size                       = 10
  default_disk_type                       = "PD_SSD"
  default_pricing_plan                    = "PER_USE"
  default_maintenance_window_day          = 1
  default_maintenance_window_hour         = 23
  default_replication_type                = "SYNCHRONOUS"
  default_maintenance_window_update_track = "canary"

  default_user_password = ""
  default_user_host     = "%"

  primary_zone       = "${lookup(var.master, "zone")}"
  read_replica_zones = ["${compact(split(",", lookup(var.read_replica, "zones", "")))}"]

  zone_mapping = {
    enabled  = ["${local.read_replica_zones}"]
    disabled = "${list(local.primary_zone)}"
  }

  zones_enabled = "${length(local.read_replica_zones) > 0}"
  mod_by        = "${local.zones_enabled ? length(local.read_replica_zones) : 1}"

  zones = "${local.zone_mapping["${local.zones_enabled ? "enabled" : "disabled"}"]}"
}

resource "google_sql_database_instance" "master" {
  project          = "${var.project_id}"
  name             = "${var.name}"
  database_version = "${var.database_version}"
  region           = "${var.region}"

  settings {
    tier                        = "${lookup(var.master, "tier", local.default_tier)}"
    activation_policy           = "${lookup(var.master, "activation_policy", local.default_activation_policy)}"
    authorized_gae_applications = ["${var.authorized_gae_applications}"]
    backup_configuration        = ["${var.backup_configuration}"]
    ip_configuration            = ["${var.ip_configuration}"]

    disk_autoresize = "${lookup(var.master, "disk_autoresize", local.default_disk_autoresize)}"

    disk_size      = "${lookup(var.master, "disk_size", local.default_disk_size)}"
    disk_type      = "${lookup(var.master, "disk_type", local.default_disk_type)}"
    pricing_plan   = "${lookup(var.master, "pricing_plan", local.default_pricing_plan)}"
    user_labels    = "${var.master_labels}"
    database_flags = ["${var.master_database_flags}"]

    location_preference {
      zone = "${var.region}-${lookup(var.master, "zone")}"
    }

    maintenance_window {
      day          = "${lookup(var.master, "maintenance_window_day", local.default_maintenance_window_day)}"
      hour         = "${lookup(var.master, "maintenance_window_hour", local.default_maintenance_window_hour)}"
      update_track = "${lookup(var.master, "maintenance_window_update_track", local.default_maintenance_window_update_track)}"
    }
  }

  lifecycle {
    ignore_changes = ["disk_size"]
  }
}

resource "google_sql_database_instance" "replicas" {
  count                 = "${lookup(var.read_replica, "length", 0)}"
  project               = "${var.project_id}"
  name                  = "${var.name}-replica${count.index}"
  database_version      = "${var.database_version}"
  region                = "${var.region}"
  master_instance_name  = "${google_sql_database_instance.master.name}"
  replica_configuration = ["${merge(var.replica_configuration, map("failover_target", false))}"]

  settings {
    tier                        = "${lookup(var.read_replica, "tier", local.default_tier)}"
    activation_policy           = "${lookup(var.read_replica, "activation_policy", local.default_activation_policy)}"
    authorized_gae_applications = ["${var.authorized_gae_applications}"]
    ip_configuration            = ["${var.ip_configuration}"]

    crash_safe_replication = "${lookup(var.read_replica, "crash_safe_replication", local.default_crash_safe_replication)}"
    disk_autoresize        = "${lookup(var.read_replica, "disk_autoresize", local.default_disk_autoresize)}"
    disk_size              = "${lookup(var.read_replica, "disk_size", local.default_disk_size)}"
    disk_type              = "${lookup(var.read_replica, "disk_type", local.default_disk_type)}"
    pricing_plan           = "${lookup(var.read_replica, "pricing_plan", local.default_pricing_plan)}"
    replication_type       = "${lookup(var.read_replica, "replication_type", local.default_replication_type)}"
    user_labels            = "${var.read_replica_labels}"
    database_flags         = ["${var.read_replica_database_flags}"]

    location_preference {
      zone = "${length(local.zones) == 0 ? "" : "${var.region}-${local.zones[count.index % local.mod_by]}"}"
    }

    maintenance_window {
      day          = "${lookup(var.read_replica, "maintenance_window_day", local.default_maintenance_window_day)}"
      hour         = "${lookup(var.read_replica, "maintenance_window_hour", local.default_maintenance_window_hour)}"
      update_track = "${lookup(var.read_replica, "maintenance_window_update_track", local.default_maintenance_window_update_track)}"
    }
  }

  depends_on = ["google_sql_database_instance.master"]

  lifecycle {
    ignore_changes = ["disk_size"]
  }
}

resource "google_sql_database_instance" "failover-replica" {
  count                 = "${length(var.failover_replica) == 0 ? 0 : 1}"
  project               = "${var.project_id}"
  name                  = "${var.name}-failover"
  database_version      = "${var.database_version}"
  region                = "${var.region}"
  master_instance_name  = "${google_sql_database_instance.master.name}"
  replica_configuration = ["${merge(var.replica_configuration, map("failover_target", true))}"]

  settings {
    tier                        = "${lookup(var.failover_replica, "tier", local.default_tier)}"
    activation_policy           = "${lookup(var.failover_replica, "activation_policy", local.default_activation_policy)}"
    authorized_gae_applications = ["${var.authorized_gae_applications}"]
    ip_configuration            = ["${var.ip_configuration}"]

    crash_safe_replication = "${lookup(var.failover_replica, "crash_safe_replication", local.default_crash_safe_replication)}"
    disk_autoresize        = "${lookup(var.failover_replica, "disk_autoresize", local.default_disk_autoresize)}"
    disk_size              = "${lookup(var.failover_replica, "disk_size", local.default_disk_size)}"
    disk_type              = "${lookup(var.failover_replica, "disk_type", local.default_disk_type)}"
    pricing_plan           = "${lookup(var.failover_replica, "pricing_plan", local.default_pricing_plan)}"
    replication_type       = "${lookup(var.failover_replica, "replication_type", local.default_replication_type)}"
    user_labels            = "${var.failover_replica_labels}"
    database_flags         = ["${var.failover_replica_database_flags}"]

    location_preference {
      zone = "${var.region}-${lookup(var.failover_replica, "zone")}"
    }

    maintenance_window {
      day          = "${lookup(var.failover_replica, "maintenance_window_day", local.default_maintenance_window_day)}"
      hour         = "${lookup(var.failover_replica, "maintenance_window_hour", local.default_maintenance_window_hour)}"
      update_track = "${lookup(var.failover_replica, "maintenance_window_update_track", local.default_maintenance_window_update_track)}"
    }
  }

  depends_on = ["google_sql_database_instance.master"]

  lifecycle {
    ignore_changes = ["disk_size"]
  }
}

resource "google_sql_database" "default" {
  project    = "${var.project_id}"
  name       = "${var.name}"
  charset    = "${var.charset}"
  collation  = "${var.collation}"
  instance   = "${google_sql_database_instance.master.name}"
  depends_on = ["google_sql_database_instance.master"]
}

resource "google_sql_user" "users" {
  count      = "${length(var.users)}"
  project    = "${var.project_id}"
  instance   = "${google_sql_database_instance.master.name}"
  name       = "${lookup(var.users[count.index], "name")}"
  password   = "${lookup(var.users[count.index], "password", local.default_user_password)}"
  host       = "${lookup(var.users[count.index], "host", local.default_user_host)}"
  depends_on = ["google_sql_database_instance.master"]
}

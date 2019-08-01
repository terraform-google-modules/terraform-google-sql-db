/**
 * Copyright 2019 Google LLC
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
  failover_replica_ip_configuration_enabled = length(keys(var.failover_replica_ip_configuration)) > 0 ? true : false

  failover_replica_ip_configurations = {
    enabled  = var.failover_replica_ip_configuration
    disabled = {}
  }
}

resource "google_sql_database_instance" "failover-replica" {
  count                = var.failover_replica ? 1 : 0
  project              = var.project_id
  name                 = "${var.name}-failover${var.failover_replica_name_suffix}"
  database_version     = var.database_version
  region               = var.region
  master_instance_name = google_sql_database_instance.default.name
  dynamic "replica_configuration" {
    for_each = [var.failover_replica_configuration]
    content {
      ca_certificate            = lookup(replica_configuration.value, "ca_certificate", null)
      client_certificate        = lookup(replica_configuration.value, "client_certificate", null)
      client_key                = lookup(replica_configuration.value, "client_key", null)
      connect_retry_interval    = lookup(replica_configuration.value, "connect_retry_interval", null)
      dump_file_path            = lookup(replica_configuration.value, "dump_file_path", null)
      failover_target           = lookup(replica_configuration.value, "failover_target", true)
      master_heartbeat_period   = lookup(replica_configuration.value, "master_heartbeat_period", null)
      password                  = lookup(replica_configuration.value, "password", null)
      ssl_cipher                = lookup(replica_configuration.value, "ssl_cipher", null)
      username                  = lookup(replica_configuration.value, "username", null)
      verify_server_certificate = lookup(replica_configuration.value, "verify_server_certificate", null)
    }
  }

  settings {
    tier                        = var.failover_replica_tier
    activation_policy           = var.failover_replica_activation_policy
    authorized_gae_applications = var.authorized_gae_applications
    dynamic "ip_configuration" {
      for_each = [local.failover_replica_ip_configurations[local.failover_replica_ip_configuration_enabled ? "enabled" : "disabled"]]
      content {
        ipv4_enabled    = lookup(ip_configuration.value, "ipv4_enabled", null)
        private_network = lookup(ip_configuration.value, "private_network", null)
        require_ssl     = lookup(ip_configuration.value, "require_ssl", null)

        dynamic "authorized_networks" {
          for_each = lookup(ip_configuration.value, "authorized_networks", [])
          content {
            expiration_time = lookup(authorized_networks.value, "expiration_time", null)
            name            = lookup(authorized_networks.value, "name", null)
            value           = lookup(authorized_networks.value, "value", null)
          }
        }
      }
    }

    crash_safe_replication = var.failover_replica_crash_safe_replication
    disk_autoresize        = var.failover_replica_disk_autoresize
    disk_size              = var.failover_replica_disk_size
    disk_type              = var.failover_replica_disk_type
    pricing_plan           = var.failover_replica_pricing_plan
    replication_type       = var.failover_replica_replication_type
    user_labels            = var.failover_replica_user_labels
    dynamic "database_flags" {
      for_each = var.failover_replica_database_flags
      content {
        name  = lookup(database_flags.value, "name", null)
        value = lookup(database_flags.value, "value", null)
      }
    }

    location_preference {
      zone = "${var.region}-${var.failover_replica_zone}"
    }

    maintenance_window {
      day          = var.failover_replica_maintenance_window_day
      hour         = var.failover_replica_maintenance_window_hour
      update_track = var.failover_replica_maintenance_window_update_track
    }
  }

  depends_on = [google_sql_database_instance.default]

  lifecycle {
    ignore_changes = [
      settings[0].disk_size
    ]
  }

  timeouts {
    create = var.create_timeout
    update = var.update_timeout
    delete = var.delete_timeout
  }
}


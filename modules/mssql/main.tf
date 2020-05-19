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
  ip_configuration_enabled  = length(keys(var.ip_configuration)) > 0 ? true : false
  peering_completed_enabled = var.peering_completed != "" ? true : false
  peering_completed         = local.peering_completed_enabled ? "enabled" : "disabled"

  ip_configurations = {
    enabled  = var.ip_configuration
    disabled = {}
  }

  user_labels_including_tf_dependency = {
    enabled  = merge(map("tf_dependency", var.peering_completed), var.user_labels)
    disabled = var.user_labels
  }
}

resource "random_password" "root-password" {
  length  = 8
  special = true
}

resource "google_sql_database_instance" "default" {
  provider         = google-beta
  project          = var.project_id
  name             = var.name
  database_version = var.database_version
  region           = var.region
  root_password    = coalesce(var.root_password, random_password.root-password.result)

  settings {
    tier                        = var.tier
    activation_policy           = var.activation_policy
    availability_type           = var.availability_type
    authorized_gae_applications = var.authorized_gae_applications
    dynamic "ip_configuration" {
      for_each = [local.ip_configurations[local.ip_configuration_enabled ? "enabled" : "disabled"]]
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

    disk_autoresize = var.disk_autoresize
    disk_size       = var.disk_size
    disk_type       = var.disk_type
    pricing_plan    = var.pricing_plan
    dynamic "database_flags" {
      for_each = var.database_flags
      content {
        name  = lookup(database_flags.value, "name", null)
        value = lookup(database_flags.value, "value", null)
      }
    }

    // Define a label to force a dependency to the creation of the network peering.
    // Substitute this with a module dependency once the module is migrated to
    // Terraform 0.12
    user_labels = local.user_labels_including_tf_dependency[local.peering_completed]

    location_preference {
      zone = var.zone
    }

    maintenance_window {
      day          = var.maintenance_window_day
      hour         = var.maintenance_window_hour
      update_track = var.maintenance_window_update_track
    }
  }

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

resource "google_sql_database" "default" {
  name       = var.db_name
  project    = var.project_id
  instance   = google_sql_database_instance.default.name
  charset    = var.db_charset
  collation  = var.db_collation
  depends_on = [google_sql_database_instance.default, google_sql_user.default, google_sql_user.additional_users]
}

resource "google_sql_database" "additional_databases" {
  count      = length(var.additional_databases)
  project    = var.project_id
  name       = var.additional_databases[count.index]["name"]
  charset    = lookup(var.additional_databases[count.index], "charset", "")
  collation  = lookup(var.additional_databases[count.index], "collation", "")
  instance   = google_sql_database_instance.default.name
  depends_on = [google_sql_database_instance.default, google_sql_user.default, google_sql_user.additional_users]
}

resource "random_password" "user-password" {
  length  = 8
  special = true
}

resource "google_sql_user" "default" {
  name       = var.user_name
  project    = var.project_id
  instance   = google_sql_database_instance.default.name
  password   = coalesce(var.user_password, random_password.user-password.result)
  depends_on = [google_sql_database_instance.default]
}

resource "google_sql_user" "additional_users" {
  count   = length(var.additional_users)
  project = var.project_id
  name    = var.additional_users[count.index]["name"]
  password = lookup(
    var.additional_users[count.index],
    "password",
    random_password.user-password.result,
  )
  instance   = google_sql_database_instance.default.name
  depends_on = [google_sql_database_instance.default]
}

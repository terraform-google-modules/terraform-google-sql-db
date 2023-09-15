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
  replicas = {
    for x in var.read_replicas : "${var.name}-replica${var.read_replica_name_suffix}${x.name}" => x
  }
  // Zone for replica instances
  zone = var.zone == null ? data.google_compute_zones.available[0].names[0] : var.zone
}

data "google_compute_zones" "available" {
  count   = var.zone == null ? 0 : 1
  project = var.project_id
  region  = var.region
}

resource "google_sql_database_instance" "replicas" {
  provider             = google-beta
  for_each             = local.replicas
  project              = var.project_id
  name                 = each.value.name_override == null || each.value.name_override == "" ? "${local.master_instance_name}-replica${var.read_replica_name_suffix}${each.value.name}" : each.value.name_override
  database_version     = var.database_version
  region               = join("-", slice(split("-", coalesce(each.value["zone"], local.zone)), 0, 2))
  master_instance_name = google_sql_database_instance.default.name
  deletion_protection  = var.read_replica_deletion_protection
  encryption_key_name  = (join("-", slice(split("-", coalesce(each.value["zone"], local.zone)), 0, 2))) == var.region ? null : each.value.encryption_key_name

  replica_configuration {
    failover_target = false
  }

  settings {
    tier                        = coalesce(each.value["tier"], var.tier)
    edition                     = coalesce(each.value["edition"], var.edition)
    activation_policy           = "ALWAYS"
    availability_type           = coalesce(each.value["availability_type"], var.availability_type)
    deletion_protection_enabled = var.read_replica_deletion_protection_enabled

    dynamic "ip_configuration" {
      for_each = [lookup(each.value, "ip_configuration", {})]
      content {
        ipv4_enabled                                  = lookup(ip_configuration.value, "ipv4_enabled", null)
        private_network                               = lookup(ip_configuration.value, "private_network", null)
        require_ssl                                   = lookup(ip_configuration.value, "require_ssl", null)
        allocated_ip_range                            = lookup(ip_configuration.value, "allocated_ip_range", null)
        enable_private_path_for_google_cloud_services = lookup(ip_configuration.value, "enable_private_path_for_google_cloud_services", false)

        dynamic "authorized_networks" {
          for_each = lookup(ip_configuration.value, "authorized_networks", [])
          content {
            expiration_time = lookup(authorized_networks.value, "expiration_time", null)
            name            = lookup(authorized_networks.value, "name", null)
            value           = lookup(authorized_networks.value, "value", null)
          }
        }
        dynamic "psc_config" {
          for_each = ip_configuration.value.psc_enabled ? ["psc_enabled"] : []
          content {
            psc_enabled               = ip_configuration.value.psc_enabled
            allowed_consumer_projects = ip_configuration.value.psc_allowed_consumer_projects
          }
        }
      }
    }
    dynamic "insights_config" {
      for_each = lookup(each.value, "insights_config") != null ? [lookup(each.value, "insights_config")] : var.insights_config != null ? [var.insights_config] : []

      content {
        query_insights_enabled  = true
        query_plans_per_minute  = lookup(insights_config.value, "query_plans_per_minute", 5)
        query_string_length     = lookup(insights_config.value, "query_string_length", 1024)
        record_application_tags = lookup(insights_config.value, "record_application_tags", false)
        record_client_address   = lookup(insights_config.value, "record_client_address", false)
      }
    }

    disk_autoresize       = coalesce(each.value["disk_autoresize"], var.disk_autoresize)
    disk_autoresize_limit = coalesce(each.value["disk_autoresize_limit"], var.disk_autoresize_limit)
    disk_size             = coalesce(each.value["disk_size"], var.disk_size)
    disk_type             = coalesce(each.value["disk_type"], var.disk_type)
    pricing_plan          = "PER_USE"
    user_labels           = coalesce(each.value["user_labels"], var.user_labels)

    dynamic "database_flags" {
      for_each = lookup(each.value, "database_flags", [])
      content {
        name  = lookup(database_flags.value, "name", null)
        value = lookup(database_flags.value, "value", null)
      }
    }

    location_preference {
      zone = coalesce(each.value["zone"], local.zone)
    }

  }

  depends_on = [google_sql_database_instance.default]

  lifecycle {
    ignore_changes = [
      settings[0].disk_size,
      settings[0].maintenance_window,
      encryption_key_name,
    ]
  }

  timeouts {
    create = var.create_timeout
    update = var.update_timeout
    delete = var.delete_timeout
  }
}

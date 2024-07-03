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
  instance_name         = var.random_instance_name ? "${var.name}-${random_id.suffix[0].hex}" : var.name
  is_secondary_instance = var.master_instance_name != null

  ip_configuration_enabled = length(keys(var.ip_configuration)) > 0 ? true : false

  ip_configurations = {
    enabled  = var.ip_configuration
    disabled = {}
  }

  databases = { for db in var.additional_databases : db.name => db }
  users     = { for u in var.additional_users : u.name => u }
  iam_users = {
    for user in var.iam_users : user.id => {
      email         = user.email,
      is_account_sa = trimsuffix(user.email, "gserviceaccount.com") == user.email ? false : true
    }
  }

  // HA method using REGIONAL availability_type requires point in time recovery to be enabled
  point_in_time_recovery_enabled = var.availability_type == "REGIONAL" ? lookup(var.backup_configuration, "point_in_time_recovery_enabled", true) : lookup(var.backup_configuration, "point_in_time_recovery_enabled", false)
  backups_enabled                = var.availability_type == "REGIONAL" ? lookup(var.backup_configuration, "enabled", true) : lookup(var.backup_configuration, "enabled", false)

  retained_backups = lookup(var.backup_configuration, "retained_backups", null)
  retention_unit   = lookup(var.backup_configuration, "retention_unit", null)

  // Force the usage of connector_enforcement
  connector_enforcement = var.connector_enforcement ? "REQUIRED" : "NOT_REQUIRED"

  database_name = var.enable_default_db ? google_sql_database.default[0].name : (length(local.databases) > 0 ? google_sql_database.additional_databases[0].name : "")
}

resource "random_id" "suffix" {
  count = var.random_instance_name ? 1 : 0

  byte_length = 4
}

resource "google_sql_database_instance" "default" {
  provider            = google-beta
  project             = var.project_id
  name                = local.instance_name
  database_version    = can(regex("\\d", substr(var.database_version, 0, 1))) ? format("POSTGRES_%s", var.database_version) : replace(var.database_version, substr(var.database_version, 0, 8), "POSTGRES")
  region              = var.region
  encryption_key_name = var.encryption_key_name
  deletion_protection = var.deletion_protection
  root_password       = var.root_password

  master_instance_name = var.master_instance_name
  instance_type        = local.is_secondary_instance ? "READ_REPLICA_INSTANCE" : var.instance_type

  settings {
    tier                        = var.tier
    edition                     = var.edition
    activation_policy           = var.activation_policy
    availability_type           = var.availability_type
    deletion_protection_enabled = var.deletion_protection_enabled
    connector_enforcement       = local.connector_enforcement

    dynamic "backup_configuration" {
      for_each = local.is_secondary_instance ? [] : [var.backup_configuration]
      content {
        enabled                        = local.backups_enabled
        start_time                     = lookup(backup_configuration.value, "start_time", null)
        location                       = lookup(backup_configuration.value, "location", null)
        point_in_time_recovery_enabled = local.point_in_time_recovery_enabled
        transaction_log_retention_days = lookup(backup_configuration.value, "transaction_log_retention_days", null)

        dynamic "backup_retention_settings" {
          for_each = local.retained_backups != null || local.retention_unit != null ? [var.backup_configuration] : []
          content {
            retained_backups = local.retained_backups
            retention_unit   = local.retention_unit
          }
        }
      }
    }
    dynamic "data_cache_config" {
      for_each = var.edition == "ENTERPRISE_PLUS" && var.data_cache_enabled ? ["cache_enabled"] : []
      content {
        data_cache_enabled = var.data_cache_enabled
      }
    }
    dynamic "deny_maintenance_period" {
      for_each = local.is_secondary_instance ? [] : var.deny_maintenance_period
      content {
        end_date   = lookup(deny_maintenance_period.value, "end_date", null)
        start_date = lookup(deny_maintenance_period.value, "start_date", null)
        time       = lookup(deny_maintenance_period.value, "time", null)
      }
    }
    dynamic "ip_configuration" {
      for_each = [local.ip_configurations[local.ip_configuration_enabled ? "enabled" : "disabled"]]
      content {
        ipv4_enabled                                  = lookup(ip_configuration.value, "ipv4_enabled", null)
        private_network                               = lookup(ip_configuration.value, "private_network", null)
        require_ssl                                   = lookup(ip_configuration.value, "require_ssl", null)
        ssl_mode                                      = lookup(ip_configuration.value, "ssl_mode", null)
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
      for_each = var.insights_config != null ? [var.insights_config] : []

      content {
        query_insights_enabled  = true
        query_plans_per_minute  = lookup(insights_config.value, "query_plans_per_minute", 5)
        query_string_length     = lookup(insights_config.value, "query_string_length", 1024)
        record_application_tags = lookup(insights_config.value, "record_application_tags", false)
        record_client_address   = lookup(insights_config.value, "record_client_address", false)
      }
    }

    dynamic "password_validation_policy" {
      for_each = !local.is_secondary_instance && var.password_validation_policy_config != null ? [var.password_validation_policy_config] : []

      content {
        enable_password_policy      = true
        min_length                  = lookup(password_validation_policy.value, "min_length", 8)
        complexity                  = lookup(password_validation_policy.value, "complexity", "COMPLEXITY_DEFAULT")
        reuse_interval              = lookup(password_validation_policy.value, "reuse_interval", null)
        disallow_username_substring = lookup(password_validation_policy.value, "disallow_username_substring", true)
        password_change_interval    = lookup(password_validation_policy.value, "password_change_interval", null)
      }
    }

    disk_autoresize       = var.disk_autoresize
    disk_autoresize_limit = var.disk_autoresize_limit
    disk_size             = var.disk_size
    disk_type             = var.disk_type
    pricing_plan          = var.pricing_plan

    dynamic "database_flags" {
      for_each = var.database_flags
      content {
        name  = lookup(database_flags.value, "name", null)
        value = lookup(database_flags.value, "value", null)
      }
    }

    user_labels = var.user_labels

    dynamic "location_preference" {
      for_each = var.zone != null ? ["location_preference"] : []
      content {
        zone                   = var.zone
        secondary_zone         = local.is_secondary_instance ? null : var.secondary_zone
        follow_gae_application = local.is_secondary_instance ? null : var.follow_gae_application
      }
    }

    dynamic "maintenance_window" {
      for_each = local.is_secondary_instance ? [] : ["maintenance_window"]
      content {
        day          = var.maintenance_window_day
        hour         = var.maintenance_window_hour
        update_track = var.maintenance_window_update_track
      }
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

  depends_on = [null_resource.module_depends_on]
}

resource "google_sql_database" "default" {
  count           = var.enable_default_db ? 1 : 0
  name            = var.db_name
  project         = var.project_id
  instance        = google_sql_database_instance.default.name
  charset         = var.db_charset
  collation       = var.db_collation
  depends_on      = [null_resource.module_depends_on, google_sql_database_instance.default]
  deletion_policy = var.database_deletion_policy
}

resource "google_sql_database" "additional_databases" {
  for_each        = local.databases
  project         = var.project_id
  name            = each.value.name
  charset         = lookup(each.value, "charset", null)
  collation       = lookup(each.value, "collation", null)
  instance        = google_sql_database_instance.default.name
  depends_on      = [null_resource.module_depends_on, google_sql_database_instance.default]
  deletion_policy = var.database_deletion_policy
}

resource "random_password" "user-password" {
  count = var.enable_default_user ? 1 : 0
  keepers = {
    name = google_sql_database_instance.default.name
  }
  min_lower   = 1
  min_numeric = 1
  min_upper   = 1
  length      = var.password_validation_policy_config != null ? (var.password_validation_policy_config.min_length != null ? var.password_validation_policy_config.min_length + 4 : 32) : 32
  special     = var.enable_random_password_special ? true : (var.password_validation_policy_config != null ? (var.password_validation_policy_config.complexity == "COMPLEXITY_DEFAULT" ? true : false) : false)
  min_special = var.enable_random_password_special ? 1 : (var.password_validation_policy_config != null ? (var.password_validation_policy_config.complexity == "COMPLEXITY_DEFAULT" ? 1 : 0) : 0)
  depends_on  = [null_resource.module_depends_on, google_sql_database_instance.default]

  lifecycle {
    ignore_changes = [
      min_lower, min_upper, min_numeric, special, min_special, length
    ]
  }
}

resource "random_password" "additional_passwords" {
  for_each = local.users

  keepers = {
    name = google_sql_database_instance.default.name
  }
  min_lower   = 1
  min_numeric = 1
  min_upper   = 1
  length      = var.password_validation_policy_config != null ? (var.password_validation_policy_config.min_length != null ? var.password_validation_policy_config.min_length + 4 : 32) : 32
  special     = var.enable_random_password_special ? true : (var.password_validation_policy_config != null ? (var.password_validation_policy_config.complexity == "COMPLEXITY_DEFAULT" ? true : false) : false)
  min_special = var.enable_random_password_special ? 1 : (var.password_validation_policy_config != null ? (var.password_validation_policy_config.complexity == "COMPLEXITY_DEFAULT" ? 1 : 0) : 0)
  depends_on  = [null_resource.module_depends_on, google_sql_database_instance.default]

  lifecycle {
    ignore_changes = [
      min_lower, min_upper, min_numeric, special, min_special, length
    ]
  }
}

resource "google_sql_user" "default" {
  count    = var.enable_default_user ? 1 : 0
  name     = var.user_name
  project  = var.project_id
  instance = google_sql_database_instance.default.name
  password = var.user_password == "" ? random_password.user-password[0].result : var.user_password
  depends_on = [
    null_resource.module_depends_on,
    google_sql_database_instance.default,
    google_sql_database_instance.replicas,
  ]
  deletion_policy = var.user_deletion_policy
}

resource "google_sql_user" "additional_users" {
  for_each = local.users
  project  = var.project_id
  name     = each.value.name
  password = each.value.random_password ? random_password.additional_passwords[each.value.name].result : each.value.password
  instance = google_sql_database_instance.default.name
  depends_on = [
    null_resource.module_depends_on,
    google_sql_database_instance.default,
    google_sql_database_instance.replicas,
  ]
  deletion_policy = var.user_deletion_policy
}

resource "google_sql_user" "iam_account" {
  for_each = local.iam_users

  project = var.project_id
  name = each.value.is_account_sa ? (
    trimsuffix(each.value.email, ".gserviceaccount.com")
    ) : (
    each.value.email
  )
  instance = google_sql_database_instance.default.name
  type     = each.value.is_account_sa ? "CLOUD_IAM_SERVICE_ACCOUNT" : "CLOUD_IAM_USER"

  depends_on = [
    null_resource.module_depends_on,
  ]
  deletion_policy = var.user_deletion_policy
}

resource "null_resource" "module_depends_on" {
  triggers = {
    value = length(var.module_depends_on)
  }
}

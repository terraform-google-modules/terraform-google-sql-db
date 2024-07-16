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
  read_replica_ip_configuration = {
    ipv4_enabled       = false
    require_ssl        = false
    ssl_mode           = "ENCRYPTED_ONLY"
    private_network    = google_compute_network.default.self_link
    allocated_ip_range = null
    authorized_networks = [
      {
        name  = "${var.project_id}-cidr"
        value = var.pg_ha_external_ip_range
      },
    ]
  }
  edition            = "ENTERPRISE_PLUS"
  tier               = local.edition == "ENTERPRISE_PLUS" ? "db-perf-optimized-N-2" : "db-custom-2-7680"
  data_cache_enabled = local.edition == "ENTERPRISE_PLUS" ? true : false
}

data "google_compute_zones" "available_region1" {
  project = var.project_id
  region  = local.region_1
}

data "google_compute_zones" "available_region2" {
  project = var.project_id
  region  = local.region_2
}

// Primary instance with read replicas.

module "pg1" {
  source  = "terraform-google-modules/sql-db/google//modules/postgresql"
  version = "~> 21.0"


  name                 = var.pg_name_1
  random_instance_name = true
  project_id           = var.project_id
  database_version     = "POSTGRES_14"
  region               = local.region_1

  edition            = local.edition
  data_cache_enabled = local.data_cache_enabled

  encryption_key_name = google_kms_crypto_key.cloudsql_region1_key.id

  tier                            = local.tier
  zone                            = data.google_compute_zones.available_region1.names[0]
  availability_type               = "REGIONAL"
  maintenance_window_day          = 7
  maintenance_window_hour         = 12
  maintenance_window_update_track = "stable"

  deny_maintenance_period = [
    {
      end_date   = "2025-2-1"
      start_date = "2025-1-1"
      time       = "00:00:00"
    }
  ]

  insights_config = {
    query_plans_per_minute = 5
  }

  password_validation_policy_config = {
    min_length = 10
  }

  deletion_protection = false

  database_flags = [{ name = "autovacuum", value = "off" }]

  user_labels = {
    foo      = "bar"
    instance = "instance-1"
  }

  ip_configuration = {
    ipv4_enabled       = false
    require_ssl        = true
    private_network    = google_compute_network.default.self_link
    allocated_ip_range = null
    authorized_networks = [
      {
        name  = "${var.project_id}-cidr"
        value = var.pg_ha_external_ip_range
      },
    ]
  }

  backup_configuration = {
    enabled                        = true
    start_time                     = "20:55"
    location                       = null
    point_in_time_recovery_enabled = true
    transaction_log_retention_days = null
    retained_backups               = 365
    retention_unit                 = "COUNT"
  }

  // Read replica configurations
  read_replica_name_suffix = "-rr-"
  read_replicas = [
    {
      name                  = "0"
      zone                  = data.google_compute_zones.available_region1.names[1]
      availability_type     = "ZONAL"
      ip_configuration      = local.read_replica_ip_configuration
      database_flags        = [{ name = "autovacuum", value = "off" }]
      disk_autoresize       = null
      disk_autoresize_limit = null
      disk_size             = null
      disk_type             = "PD_SSD"
      user_labels           = { bar = "baz" }
      encryption_key_name   = null
      encryption_key_name   = google_kms_crypto_key.cloudsql_region1_key.id
      insights_config = {
        query_plans_per_minute = 5
      }
    },
  ]

  db_name      = var.pg_name_1
  db_charset   = "UTF8"
  db_collation = "en_US.UTF8"

  enable_default_db   = false
  enable_default_user = false

  depends_on = [
    google_service_networking_connection.vpc_connection,
    google_kms_crypto_key_iam_member.crypto_key_region1,
  ]

}

// Failover Replica instance with its own read replicas

module "pg2" {
  source  = "terraform-google-modules/sql-db/google//modules/postgresql"
  version = "~> 21.0"


  # Comment this parameter to promot instance 2 as primary instance. This will break replication between instance 1 and 2
  master_instance_name = module.pg1.instance_name

  name                 = var.pg_name_2
  random_instance_name = true
  project_id           = var.project_id
  database_version     = "POSTGRES_14"
  region               = local.region_2

  edition            = local.edition
  data_cache_enabled = local.data_cache_enabled

  encryption_key_name = google_kms_crypto_key.cloudsql_region2_key.id

  tier                            = local.tier
  zone                            = data.google_compute_zones.available_region2.names[0]
  availability_type               = "ZONAL"
  maintenance_window_day          = 7
  maintenance_window_hour         = 12
  maintenance_window_update_track = "stable"


  deny_maintenance_period = [
    {
      end_date   = "2025-2-1"
      start_date = "2025-1-1"
      time       = "00:00:00"
    }
  ]

  insights_config = {
    query_plans_per_minute = 5
  }

  password_validation_policy_config = {
    min_length = 10
  }

  deletion_protection = false


  database_flags = [{ name = "autovacuum", value = "off" }]

  user_labels = {
    foo      = "bar"
    instance = "instance-2"
  }

  ip_configuration = {
    ipv4_enabled       = false
    require_ssl        = true
    private_network    = google_compute_network.default.self_link
    allocated_ip_range = null
    authorized_networks = [
      {
        name  = "${var.project_id}-cidr"
        value = var.pg_ha_external_ip_range
      },
    ]
  }

  backup_configuration = {
    enabled                        = true
    start_time                     = "20:55"
    location                       = null
    point_in_time_recovery_enabled = true
    transaction_log_retention_days = null
    retained_backups               = 365
    retention_unit                 = "COUNT"
  }

  // Read replica configurations
  read_replica_name_suffix = "-rr-"
  read_replicas = [
    {
      name                  = "0"
      zone                  = data.google_compute_zones.available_region2.names[1]
      availability_type     = "ZONAL"
      ip_configuration      = local.read_replica_ip_configuration
      database_flags        = [{ name = "autovacuum", value = "off" }]
      disk_autoresize       = null
      disk_autoresize_limit = null
      disk_size             = null
      disk_type             = "PD_SSD"
      user_labels           = { bar = "baz" }
      encryption_key_name   = null
      encryption_key_name   = google_kms_crypto_key.cloudsql_region2_key.id
      insights_config = {
        query_plans_per_minute = 5
      }
    },
  ]

  enable_default_db   = false
  enable_default_user = false

  depends_on = [
    google_service_networking_connection.vpc_connection,
    google_kms_crypto_key_iam_member.crypto_key_region2,
  ]

}

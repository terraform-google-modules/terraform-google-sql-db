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

provider "google" {
}

resource "random_id" "instance_name_suffix" {
  byte_length = 5
}

locals {
  /*
    Random instance name needed because:
    "You cannot reuse an instance name for up to a week after you have deleted an instance."
    See https://cloud.google.com/sql/docs/mysql/delete-instance for details.
  */
  instance_name = "${var.pg_ha_name}-${random_id.instance_name_suffix.hex}"
}

module "pg" {
  source           = "../../../modules/postgresql"
  name             = local.instance_name
  project_id       = var.project
  database_version = "POSTGRES_9_6"
  region           = "us-central1"

  // Master configurations
  tier                            = "db-custom-2-13312"
  zone                            = "c"
  availability_type               = "REGIONAL"
  maintenance_window_day          = 7
  maintenance_window_hour         = 12
  maintenance_window_update_track = "stable"

  database_flags = [
    {
      name  = "autovacuum"
      value = "off"
    },
  ]

  user_labels = {
    foo = "bar"
  }

  ip_configuration = {
    ipv4_enabled    = true
    require_ssl     = true
    private_network = null
    authorized_networks = [
      {
        name  = "${var.project}-cidr"
        value = var.pg_ha_external_ip_range
      },
    ]
  }

  backup_configuration = {
    enabled            = true
    binary_log_enabled = false
    start_time         = "20:55"
  }

  // Read replica configurations
  read_replica_name_suffix                     = "-test"
  read_replica_size                            = 3
  read_replica_tier                            = "db-custom-2-13312"
  read_replica_zones                           = "a,b,c"
  read_replica_activation_policy               = "ALWAYS"
  read_replica_crash_safe_replication          = true
  read_replica_disk_autoresize                 = true
  read_replica_disk_type                       = "PD_HDD"
  read_replica_replication_type                = "SYNCHRONOUS"
  read_replica_maintenance_window_day          = 1
  read_replica_maintenance_window_hour         = 22
  read_replica_maintenance_window_update_track = "stable"

  read_replica_user_labels = {
    bar = "baz"
  }

  read_replica_database_flags = [
    {
      name  = "autovacuum"
      value = "off"
    },
  ]

  read_replica_configuration = {
    dump_file_path            = "gs://${var.project}.appspot.com/tmp"
    connect_retry_interval    = 5
    ca_certificate            = null
    client_certificate        = null
    client_key                = null
    failover_target           = null
    master_heartbeat_period   = null
    password                  = null
    ssl_cipher                = null
    username                  = null
    verify_server_certificate = null
  }

  read_replica_ip_configuration = {
    ipv4_enabled    = true
    require_ssl     = false
    private_network = null
    authorized_networks = [
      {
        name  = "${var.project}-cidr"
        value = var.pg_ha_external_ip_range
      },
    ]
  }

  db_name      = var.pg_ha_name
  db_charset   = "UTF8"
  db_collation = "en_US.UTF8"

  additional_databases = [
    {
      name      = "${var.pg_ha_name}-additional"
      charset   = "UTF8"
      collation = "en_US.UTF8"
      instance  = local.instance_name
      project   = var.project
    },
  ]

  user_name     = "tftest"
  user_password = "foobar"

  additional_users = [
    {
      project  = var.project
      name     = "tftest2"
      password = "abcdefg"
      host     = "localhost"
      instance = local.instance_name
    },
    {
      project  = var.project
      name     = "tftest3"
      password = "abcdefg"
      host     = "localhost"
      instance = local.instance_name
    },
  ]
}


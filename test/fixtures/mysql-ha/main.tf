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

provider "google" {
  credentials = "${file(var.credentials_file_path)}"
}

module "mysql" {
  source           = "../../../modules/mysql"
  name             = "${var.mysql_ha_name}"
  project_id       = "${var.project}"
  database_version = "MYSQL_5_7"
  region           = "us-central1"

  // Master configurations
  tier                            = "db-n1-standard-1"
  zone                            = "c"
  maintenance_window_day          = 7
  maintenance_window_hour         = 12
  maintenance_window_update_track = "stable"

  database_flags = [
    {
      name  = "long_query_time"
      value = 1
    },
  ]

  user_labels = {
    foo = "bar"
  }

  ip_configuration {
    ipv4_enabled = true
    require_ssl  = true

    authorized_networks = [{
      name  = "${var.project}-cidr"
      value = "${var.mysql_ha_external_ip_range}"
    }]
  }

  backup_configuration {
    enabled            = true
    binary_log_enabled = true
    start_time         = "20:55"
  }

  // Read replica configurations
  read_replica_size                            = 3
  read_replica_tier                            = "db-n1-standard-1"
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

  read_replica_database_flags = [{
    name  = "long_query_time"
    value = "1"
  }]

  read_replica_configuration {
    dump_file_path         = "gs://${var.project}.appspot.com/tmp"
    connect_retry_interval = 5
  }

  read_replica_ip_configuration {
    ipv4_enabled = true
    require_ssl  = true

    authorized_networks = [{
      name  = "${var.project}-cidr"
      value = "${var.mysql_ha_external_ip_range}"
    }]
  }

  // Failover replica configurations
  failover_replica                                 = true
  failover_replica_tier                            = "db-n1-standard-1"
  failover_replica_zone                            = "a"
  failover_replica_activation_policy               = "ALWAYS"
  failover_replica_crash_safe_replication          = true
  failover_replica_disk_autoresize                 = true
  failover_replica_disk_type                       = "PD_SSD"
  failover_replica_replication_type                = "SYNCHRONOUS"
  failover_replica_maintenance_window_day          = 3
  failover_replica_maintenance_window_hour         = 20
  failover_replica_maintenance_window_update_track = "canary"

  failover_replica_user_labels = {
    baz = "boo"
  }

  failover_replica_database_flags = [{
    name  = "long_query_time"
    value = "1"
  }]

  failover_replica_configuration {
    dump_file_path         = "gs://${var.project}.appspot.com/tmp"
    connect_retry_interval = 5
  }

  failover_replica_ip_configuration {
    ipv4_enabled = true
    require_ssl  = true

    authorized_networks = [{
      name  = "${var.project}-cidr"
      value = "${var.mysql_ha_external_ip_range}"
    }]
  }

  // Users
  users = [
    {
      name     = "tftest"
      password = "foobar"
    },
  ]

  databases = [
    {
      name      = "${var.mysql_ha_name}"
      charset   = "utf8mb4"
      collation = "utf8mb4_general_ci"
    },
  ]
}

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

module "safer_mysql" {
  source                          = "../mysql"
  project_id                      = var.project_id
  name                            = var.name
  database_version                = var.database_version
  region                          = var.region
  zone                            = var.zone
  tier                            = var.tier
  activation_policy               = var.activation_policy
  authorized_gae_applications     = var.authorized_gae_applications
  disk_autoresize                 = var.disk_autoresize
  disk_size                       = var.disk_size
  disk_type                       = var.disk_type
  pricing_plan                    = var.pricing_plan
  maintenance_window_day          = var.maintenance_window_day
  maintenance_window_hour         = var.maintenance_window_hour
  maintenance_window_update_track = var.maintenance_window_update_track
  database_flags                  = var.database_flags

  // Define a label to force a dependency to the creation of the network peering.
  // Substitute this with a module dependency once the module is migrated to
  // Terraform 0.12
  user_labels = merge(
    {
      "tf_dependency" = var.peering_completed
    },
    var.user_labels,
  )

  backup_configuration = var.backup_configuration

  ip_configuration = {
    ipv4_enabled = var.assign_public_ip
    # We never set authorized networks, we need all connections via the
    # public IP to be mediated by Cloud SQL.
    authorized_networks = []
    require_ssl         = true
    private_network     = var.vpc_network
  }

  db_name      = var.db_name
  db_charset   = var.db_charset
  db_collation = var.db_collation

  additional_databases = var.additional_databases
  user_name            = var.user_name

  // All MySQL users can connect only via the Cloud SQL Proxy.
  user_host = "cloudsqlproxy~%"

  user_password    = var.user_password
  additional_users = var.additional_users

  // Read replica

  read_replica_configuration                   = var.read_replica_configuration
  read_replica_name_suffix                     = var.read_replica_name_suffix
  read_replica_size                            = var.read_replica_size
  read_replica_tier                            = var.read_replica_tier
  read_replica_zones                           = var.read_replica_zones
  read_replica_activation_policy               = var.read_replica_activation_policy
  read_replica_crash_safe_replication          = var.read_replica_crash_safe_replication
  read_replica_disk_autoresize                 = var.read_replica_disk_autoresize
  read_replica_disk_size                       = var.read_replica_disk_size
  read_replica_disk_type                       = var.read_replica_disk_type
  read_replica_pricing_plan                    = var.read_replica_pricing_plan
  read_replica_replication_type                = var.read_replica_replication_type
  read_replica_database_flags                  = var.read_replica_database_flags
  read_replica_maintenance_window_day          = var.read_replica_maintenance_window_day
  read_replica_maintenance_window_hour         = var.read_replica_maintenance_window_hour
  read_replica_maintenance_window_update_track = var.read_replica_maintenance_window_update_track
  read_replica_user_labels                     = var.read_replica_user_labels
  read_replica_ip_configuration = {
    // If the main instance needs a public IP, we'll associate one at the replica too.
    ipv4_enabled        = var.assign_public_ip
    authorized_networks = []
    private_network     = var.vpc_network
    require_ssl         = true
  }


  // Failover replica
  failover_replica                                 = var.failover_replica
  failover_replica_name_suffix                     = var.failover_replica_name_suffix
  failover_replica_configuration                   = var.failover_replica_configuration
  failover_replica_tier                            = var.failover_replica_tier
  failover_replica_zone                            = var.failover_replica_zone
  failover_replica_activation_policy               = var.failover_replica_activation_policy
  failover_replica_crash_safe_replication          = var.failover_replica_crash_safe_replication
  failover_replica_disk_autoresize                 = var.failover_replica_disk_autoresize
  failover_replica_disk_size                       = var.failover_replica_disk_size
  failover_replica_disk_type                       = var.failover_replica_disk_type
  failover_replica_pricing_plan                    = var.failover_replica_pricing_plan
  failover_replica_replication_type                = var.failover_replica_replication_type
  failover_replica_database_flags                  = var.failover_replica_database_flags
  failover_replica_maintenance_window_day          = var.failover_replica_maintenance_window_day
  failover_replica_maintenance_window_hour         = var.failover_replica_maintenance_window_hour
  failover_replica_maintenance_window_update_track = var.failover_replica_maintenance_window_update_track
  failover_replica_user_labels                     = var.failover_replica_user_labels
  failover_replica_ip_configuration = {
    ipv4_enabled        = var.assign_public_ip
    authorized_networks = []
    private_network     = var.vpc_network
    require_ssl         = true
  }
  create_timeout = var.create_timeout
  update_timeout = var.update_timeout
  delete_timeout = var.delete_timeout
}

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
  random_instance_name            = var.random_instance_name
  database_version                = var.database_version
  region                          = var.region
  zone                            = var.zone
  tier                            = var.tier
  activation_policy               = var.activation_policy
  availability_type               = var.availability_type
  disk_autoresize                 = var.disk_autoresize
  disk_size                       = var.disk_size
  disk_type                       = var.disk_type
  pricing_plan                    = var.pricing_plan
  maintenance_window_day          = var.maintenance_window_day
  maintenance_window_hour         = var.maintenance_window_hour
  maintenance_window_update_track = var.maintenance_window_update_track
  database_flags                  = var.database_flags
  encryption_key_name             = var.encryption_key_name

  deletion_protection = var.deletion_protection

  user_labels = var.user_labels

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
  read_replica_name_suffix         = var.read_replica_name_suffix
  read_replica_deletion_protection = var.read_replica_deletion_protection
  read_replicas                    = var.read_replicas

  create_timeout    = var.create_timeout
  update_timeout    = var.update_timeout
  delete_timeout    = var.delete_timeout
  module_depends_on = var.module_depends_on
}

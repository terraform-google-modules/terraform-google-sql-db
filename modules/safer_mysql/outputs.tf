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

// Master
output "instance_name" {
  value       = module.safer_mysql.instance_name
  description = "The instance name for the master instance"
}

output "instance_connection_name" {
  value       = module.safer_mysql.instance_connection_name
  description = "The connection name of the master instance to be used in connection strings"
}

output "instance_self_link" {
  value       = module.safer_mysql.instance_self_link
  description = "The URI of the master instance"
}

output "instance_service_account_email_address" {
  value       = module.safer_mysql.instance_service_account_email_address
  description = "The service account email address assigned to the master instance"
}

// Replicas

output "replicas_instance_connection_names" {
  value       = module.safer_mysql.replicas_instance_connection_names
  description = "The connection names of the replica instances to be used in connection strings"
}

output "replicas_instance_self_links" {
  value       = module.safer_mysql.replicas_instance_self_links
  description = "The URIs of the replica instances"
}

output "replicas_instance_service_account_email_addresses" {
  value       = module.safer_mysql.replicas_instance_service_account_email_addresses
  description = "The service account email addresses assigned to the replica instances"
}

output "read_replica_instance_names" {
  value       = module.safer_mysql.read_replica_instance_names
  description = "The instance names for the read replica instances"
}

// Failover Replicas
output "failover-replica_instance_connection_name" {
  value       = module.safer_mysql.failover-replica_instance_connection_name
  description = "The connection name of the failover-replica instance to be used in connection strings"
}

output "failover-replica_instance_self_link" {
  value       = module.safer_mysql.failover-replica_instance_self_link
  description = "The URI of the failover-replica instance"
}

output "failover-replica_instance_service_account_email_address" {
  value       = module.safer_mysql.failover-replica_instance_service_account_email_address
  description = "The service account email addresses assigned to the failover-replica instance"
}

output "failover-replica_instance_name" {
  value       = module.safer_mysql.failover-replica_instance_name
  description = "The instance name for the failover replica instance"
}

output "generated_user_password" {
  description = "The auto generated default user password if not input password was provided"
  value       = module.safer_mysql.generated_user_password
  sensitive   = true
}


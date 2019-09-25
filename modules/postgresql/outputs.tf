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
  value       = google_sql_database_instance.default.name
  description = "The instance name for the master instance"
}

output "instance_address" {
  value       = google_sql_database_instance.default.ip_address
  description = "The IPv4 addesses assigned for the master instance"
}

output "private_address" {
  value       = google_sql_database_instance.default.private_ip_address
  description = "The private IP address assigned for the master instance"
}

output "instance_first_ip_address" {
  value       = google_sql_database_instance.default.first_ip_address
  description = "The first IPv4 address of the addresses assigned."
}

output "instance_connection_name" {
  value       = google_sql_database_instance.default.connection_name
  description = "The connection name of the master instance to be used in connection strings"
}

output "instance_self_link" {
  value       = google_sql_database_instance.default.self_link
  description = "The URI of the master instance"
}

output "instance_server_ca_cert" {
  value       = google_sql_database_instance.default.server_ca_cert
  description = "The CA certificate information used to connect to the SQL instance via SSL"
}

output "instance_service_account_email_address" {
  value       = google_sql_database_instance.default.service_account_email_address
  description = "The service account email address assigned to the master instance"
}

// Replicas
output "replicas_instance_ip_addresses" {
  value       = google_sql_database_instance.replicas[*].ip_address
  description = "The IPv4 addresses assigned for the replica instances"
}

output "replicas_instance_connection_names" {
  value       = google_sql_database_instance.replicas[*].connection_name
  description = "The connection names of the replica instances to be used in connection strings"
}

output "replicas_instance_self_links" {
  value       = google_sql_database_instance.replicas[*].self_link
  description = "The URIs of the replica instances"
}

output "replicas_instance_server_ca_certs" {
  value       = google_sql_database_instance.replicas[*].server_ca_cert
  description = "The CA certificates information used to connect to the replica instances via SSL"
}

output "replicas_instance_service_account_email_addresses" {
  value       = google_sql_database_instance.replicas[*].service_account_email_address
  description = "The service account email addresses assigned to the replica instances"
}

output "read_replica_instance_names" {
  value       = google_sql_database_instance.replicas[*].name
  description = "The instance names for the read replica instances"
}

output "generated_user_password" {
  description = "The auto generated default user password if not input password was provided"
  value       = random_id.user-password.hex
  sensitive   = true
}

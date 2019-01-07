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

// Master
output "master_instance_first_ip_address" {
  value       = "${google_sql_database_instance.master.ip_address}"
  description = "The first IPv4 address of the addesses assigned for the master instance"
}

output "master_instance_connection_name" {
  value       = "${google_sql_database_instance.master.connection_name}"
  description = "The connection name of the master instance to be used in connection strings"
}

output "master_instance_self_link" {
  value       = "${google_sql_database_instance.master.self_link}"
  description = "The URI of the master instance"
}

output "master_instance_server_ca_cert" {
  value       = "${google_sql_database_instance.master.server_ca_cert}"
  description = "The CA certificate information used to connect to the SQL instance via SSL"
}

output "master_instance_service_account_email_address" {
  value       = "${google_sql_database_instance.master.service_account_email_address}"
  description = "The service account email address assigned to the master instance"
}

// Replicas
output "replicas_instance_first_ip_addresses" {
  value       = ["${google_sql_database_instance.replicas.*.ip_address}"]
  description = "The first IPv4 addresses of the addesses assigned for the replica instances"
}

output "replicas_instance_connection_names" {
  value       = ["${google_sql_database_instance.replicas.*.connection_name}"]
  description = "The connection names of the replica instances to be used in connection strings"
}

output "replicas_instance_self_links" {
  value       = ["${google_sql_database_instance.replicas.*.self_link}"]
  description = "The URIs of the replica instances"
}

output "replicas_instance_server_ca_certs" {
  value       = ["${google_sql_database_instance.replicas.*.server_ca_cert}"]
  description = "The CA certificates information used to connect to the replica instances via SSL"
}

output "replicas_instance_service_account_email_addresses" {
  value       = ["${google_sql_database_instance.replicas.*.service_account_email_address}"]
  description = "The service account email addresses assigned to the replica instances"
}

output "user_names" {
  value       = ["${google_sql_user.users.*.name}"]
  description = "The list of user names for the database"
}

output "user_passwords" {
  value       = ["${google_sql_user.users.*.password}"]
  description = "The list of user passwords for the database"
}

output "user_hosts" {
  value       = ["${google_sql_user.users.*.host}"]
  description = "The list of user hosts for the database"
}

output "database_names" {
  value       = ["${google_sql_database.databases.*.name}"]
  description = "The list of database names"
}

output "database_charsets" {
  value       = ["${google_sql_database.databases.*.charset}"]
  description = "The list of database charsets"
}

output "database_collation" {
  value       = ["${google_sql_database.databases.*.collation}"]
  description = "The list of database collations"
}

output "database_self_links" {
  value       = ["${google_sql_database.databases.*.self_link}"]
  description = "The URIs of the databases"
}

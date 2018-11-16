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
  value = "${google_sql_database_instance.master.ip_address}"
}

output "master_instance_connection_name" {
  value = "${google_sql_database_instance.master.connection_name}"
}

output "master_instance_self_link" {
  value = "${google_sql_database_instance.master.self_link}"
}

output "master_instance_server_ca_cert" {
  value = "${google_sql_database_instance.master.server_ca_cert}"
}

output "master_instance_service_account_email_address" {
  value = "${google_sql_database_instance.master.service_account_email_address}"
}

// Replicas
output "replicas_instance_first_ip_addresses" {
  value = ["${google_sql_database_instance.replicas.*.ip_address}"]
}

output "replicas_instance_connection_names" {
  value = ["${google_sql_database_instance.replicas.*.connection_name}"]
}

output "replicas_instance_self_links" {
  value = ["${google_sql_database_instance.replicas.*.self_link}"]
}

output "replicas_instance_server_ca_certs" {
  value = ["${google_sql_database_instance.replicas.*.server_ca_cert}"]
}

output "replicas_instance_service_account_email_addresses" {
  value = ["${google_sql_database_instance.replicas.*.service_account_email_address}"]
}

// Failover Replicas
output "failover-replica_instance_first_ip_address" {
  value = "${google_sql_database_instance.failover-replica.*.ip_address}"
}

output "failover-replica_instance_connection_name" {
  value = "${google_sql_database_instance.failover-replica.*.connection_name}"
}

output "failover-replica_instance_self_link" {
  value = "${google_sql_database_instance.failover-replica.*.self_link}"
}

output "failover-replica_instance_server_ca_cert" {
  value = "${google_sql_database_instance.failover-replica.*.server_ca_cert}"
}

output "failover-replica_instance_service_account_email_address" {
  value = "${google_sql_database_instance.failover-replica.*.service_account_email_address}"
}
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

output "project_id" {
  value       = module.example.project_id
  description = "The project to run tests against"
}

output "name" {
  value       = module.example.name
  description = "The name for Cloud SQL instance"
}

output "psql_conn" {
  value       = module.example.psql_conn
  description = "The connection name of the master instance to be used in connection strings"
}

output "psql_user_pass" {
  value       = module.example.psql_user_pass
  description = "The password for the default user. If not set, a random one will be generated and available in the generated_user_password output variable."
  sensitive   = true
}

output "public_ip_address" {
  description = "The first public (PRIMARY) IPv4 address assigned for the master instance"
  value       = module.example.public_ip_address
}


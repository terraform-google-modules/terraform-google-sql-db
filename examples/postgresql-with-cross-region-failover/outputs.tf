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
  value = var.project_id
}

// Primary instance with read replicas.

output "instance1_name" {
  description = "The name for Cloud SQL instance"
  value       = module.pg1.instance_name
}

output "instance1_replicas" {
  value     = module.pg1.replicas
  sensitive = true
}

output "instance1_instances" {
  value     = module.pg1.instances
  sensitive = true
}

output "kms_key_name1" {
  value     = module.pg1.primary.encryption_key_name
  sensitive = true
}

// Failover Replica instance with its own read replicas

output "instance2_name" {
  description = "The name for Cloud SQL instance"
  value       = module.pg2.instance_name
}

output "instance2_replicas" {
  value     = module.pg2.replicas
  sensitive = true
}

output "instance2_instances" {
  value     = module.pg2.instances
  sensitive = true
}

output "kms_key_name2" {
  value     = module.pg2.primary.encryption_key_name
  sensitive = true
}

output "master_instance_name" {
  value     = module.pg2.primary.master_instance_name
  sensitive = true
}

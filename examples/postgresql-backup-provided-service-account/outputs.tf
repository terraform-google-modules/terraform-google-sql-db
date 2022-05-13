/**
 * Copyright 2022 Google LLC
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

output "backup_workflow_name" {
  value       = module.backup.backup_workflow_name
  description = "The name for internal backup workflow"
}

output "export_workflow_name" {
  value       = module.backup.export_workflow_name
  description = "The name for export workflow"
}

output "project_id" {
  value       = var.project_id
  description = "The project ID used"
}

output "service_account" {
  value       = "${data.google_project.test_project.number}-compute@developer.gserviceaccount.com"
  description = "The service account email running the scheduler and workflow"
}

output "workflow_location" {
  value       = module.backup.region
  description = "The location where the workflows run"
}

output "instance_name" {
  value       = module.postgresql.instance_name
  description = "The name of the SQL instance"
}

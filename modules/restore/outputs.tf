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

output "import_workflow_name" {
  value       = google_workflows_workflow.sql_import.name
  description = "The name for import workflow"
}

output "service_account" {
  value       = local.service_account
  description = "The service account email running the scheduler and workflow"
}

output "region" {
  description = "The region for running the scheduler and workflow"
  value       = var.region
}

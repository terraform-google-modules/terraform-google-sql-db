/**
 * Copyright 2024 Google LLC
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

module "mssql" {
  source  = "terraform-google-modules/sql-db/google//modules/mssql"
  version = "~> 26.0"

  name                 = var.name
  random_instance_name = true
  project_id           = var.project_id
  user_name            = "simpleuser"
  user_password        = "foobar"

  deletion_protection = false

  sql_server_audit_config = var.sql_server_audit_config

  insights_config = {
    query_plans_per_minute = 5
  }

}

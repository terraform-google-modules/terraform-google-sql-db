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


module "postgresql-db" {
  source               = "../../modules/postgresql"
  name                 = var.db_name
  random_instance_name = true
  database_version     = "POSTGRES_9_6"
  project_id           = var.project_id
  zone                 = "us-central1-c"
  region               = "us-central1"
  tier                 = "db-custom-1-3840"

  deletion_protection = false

  ip_configuration = {
    ipv4_enabled        = true
    private_network     = null
    require_ssl         = true
    allocated_ip_range  = null
    authorized_networks = var.authorized_networks
  }

  password_validation_policy_config = {
    # Complexity Default - password must contain at least one lowercase, one uppercase, one number and one non-alphanumeric characters.
    complexity                  = "COMPLEXITY_DEFAULT"
    disallow_username_substring = true
    min_length                  = 8
    # Password change interval format is in seconds. 3600s=1h
    password_change_interval = "3600s"
    reuse_interval           = 1
  }

  database_flags = [
    {
      name  = "cloudsql.iam_authentication"
      value = "on"
    },
  ]

  additional_users = [
    {
      name     = "tftest2"
      password = "Ex@mp!e1"
      host     = "localhost"
    },
    {
      name     = "tftest3"
      password = "Ex@mp!e2"
      host     = "localhost"
    },
  ]

  # Supports creation of both IAM Users and IAM Service Accounts with provided emails
  iam_user_emails = [
    var.cloudsql_pg_sa,
    "dbadmin@goosecorp.org",
  ]
}

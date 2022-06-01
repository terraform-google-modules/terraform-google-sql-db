# Upgrading to SQL DB 11.0.0

The 11.0.0 release of SQL DB is a backward incompatible release. This incompatibility affects configuration of read replicas for `mysql`, `postgresql` and `safer_mysql` submodules.

## Migration Instructions

### Add support for setting disk_autoresize_limit

Prior to the 11.0.0 release, all instances could only be created without a limit.

```hcl
module "pg" {
  source  = "GoogleCloudPlatform/sql-db/google//modules/postgresql"
  version = "~> 10.0"

  project_id            = var.project_id
  region                = "europe-west1"
  zone                  = "europe-west1-d"
  name                  = "test"
  random_instance_name  = true
  availability_type     = "ZONAL"
  database_version      = "POSTGRES_14"
  disk_type             = "PD_HDD"
  disk_size             = 10
  disk_autoresize       = true
  create_timeout        = "30m"

  read_replicas = [
    {
      name                  = "0"
      zone                  = "europe-west1-d"
      tier                  = "db-f1-micro"
      disk_type             = "PD_HDD"
      disk_size             = 10
      disk_autoresize       = true
      encryption_key_name   = null
      database_flags        = []
      user_labels           = {}

      ip_configuration = {
        allocated_ip_range  = null
        authorized_networks = []
        ipv4_enabled        = true
        private_network     = null
        require_ssl         = false
      }
    },
  ]
}
```

With the 11.0.0 release, the `disk_autoresize_limit` number variable is presented which allows users to set a specific limit on how large the storage on their instance can automatically grow. The default value is zero, which means there is no limit and disk size can grow up to the maximum available storage for the instance tier. Applying the automatic disk increase limit does not cause any disruptions to your database workload.

```diff
module "pg" {
  source  = "GoogleCloudPlatform/sql-db/google//modules/postgresql"
- version = "~> 10.0"
+ version = "~> 11.0"

  project_id            = var.project_id
  region                = "europe-west1"
  zone                  = "europe-west1-d"
  name                  = "test"
  random_instance_name  = true
  availability_type     = "ZONAL"
  database_version      = "POSTGRES_14"
  disk_type             = "PD_HDD"
  disk_size             = 10
  disk_autoresize       = true
  create_timeout        = "30m"

  read_replicas = [
    {
      name                  = "0"
      zone                  = "europe-west1-d"
      tier                  = "db-f1-micro"
      disk_type             = "PD_HDD"
      disk_size             = 10
      disk_autoresize       = true
+     disk_autoresize_limit = 0
      encryption_key_name   = null
      database_flags        = []
      user_labels           = {}

      ip_configuration = {
        allocated_ip_range  = null
        authorized_networks = []
        ipv4_enabled        = true
        private_network     = null
        require_ssl         = false
      }
    },
  ]
}
```

### Switched to using random_password to generate default passwords

With the 11.0.0 release, the `random_id` resource used to generate default passwords has been replaced with `random_password` resource. This improves the default behavior by generating stronger passwords as defaults. To continue using the previously generated password and prevent updates to the `google_sql_user` resources, specify the old password via `user_password` variable or `additional_users.password`. It is recommended to store this value in [Secret Manager](https://cloud.google.com/secret-manager/docs/creating-and-accessing-secrets#secretmanager-create-secret-gcloud) as opposed to passing it in via plain text.

```diff
+ data "google_secret_manager_secret_version" "user_password" {
+  secret_id = "pg-user-pass"
+  project   = var.project_id
+ }

module "pg" {
  source  = "GoogleCloudPlatform/sql-db/google//modules/postgresql"
- version = "~> 10.0"
+ version = "~> 11.0"

  project_id    = var.project_id
+ user_password = data.google_secret_manager_secret_version.user_password.secret_data
}
```

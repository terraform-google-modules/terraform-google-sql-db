# Upgrading to SQL DB 12.0.0

The 12.0.0 release of SQL DB is a backward incompatible release. This incompatibility affects configuration of read replicas for `mysql`, `postgresql` and `safer_mysql` submodules.

## Migration Instructions

### Add support for setting availability_type

Prior to the 12.0.0 release, all read replicas were created using the default availability type set to `ZONAL`. The addition of `availability_type` allows explicit setting of availability type for each read replica.

```hcl
module "pg" {
  source  = "GoogleCloudPlatform/sql-db/google//modules/postgresql"
  version = "~> 11.0"

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
      disk_autoresize_limit = 0
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

With the 12.0.0 release, the `availability_type` string variable is presented which allows users to set the availability type of their read replicas as `ZONAL` or `REGIONAL`.

```diff
module "pg" {
  source  = "GoogleCloudPlatform/sql-db/google//modules/postgresql"
- version = "~> 11.0"
+ version = "~> 12.0"

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
+     availability_type     = "ZONAL"
      disk_autoresize_limit = 0
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

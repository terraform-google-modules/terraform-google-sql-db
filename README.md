# terraform-google-sql

terraform-google-sql makes it easy to create Google CloudSQL instance and implement high availability settings.
This module consists of the following submodules:

- [mssql](https://github.com/terraform-google-modules/terraform-google-sql-db/tree/master/modules/mssql)
- [mysql](https://github.com/terraform-google-modules/terraform-google-sql-db/tree/master/modules/mysql)
- [postgresql](https://github.com/terraform-google-modules/terraform-google-sql-db/tree/master/modules/postgresql)

See more details in each module's README.

## Compatibility
This module is meant for use with Terraform 1.3+ and tested using Terraform 1.6+.
If you find incompatibilities using Terraform `>=1.13`, please open an issue.

## Upgrading

The current version is 26.X. The following guides are available to assist with upgrades:

- [1.X -> 2.0](./docs/upgrading_to_sql_db_2.0.0.md)
- [2.X -> 3.0](./docs/upgrading_to_sql_db_3.0.0.md)
- [3.X -> 4.0](./docs/upgrading_to_sql_db_4.0.0.md)
- [10.X -> 11.0](./docs/upgrading_to_sql_db_11.0.0.md)
- [11.X -> 12.0](./docs/upgrading_to_sql_db_12.0.0.md)
- [13.X -> 14.0](./docs/upgrading_to_sql_db_14.0.0.md)
- [14.X -> 15.0](./docs/upgrading_to_sql_db_15.0.0.md)
- [16.X -> 17.0](./docs/upgrading_to_sql_db_17.0.0.md)
- [19.X -> 20.0](./docs/upgrading_to_sql_db_20.0.0.md)
- [20.X -> 21.0](./docs/upgrading_to_sql_db_21.0.md)
- [21.X -> 22.0](./docs/upgrading_to_sql_db_22.0.md)
- [22.X -> 23.0](./docs/upgrading_to_sql_db_23.0.md)
- [23.X -> 24.0](./docs/upgrading_to_sql_db_24.0.md)
- [25.X -> 26.0](./docs/upgrading_to_sql_db_26.0.md)

## Root module

The root module has been deprecated. Please switch to using one of the submodules.

## Requirements

### Installation Dependencies

- [Terraform](https://www.terraform.io/downloads.html) >= 1.3.0
- [terraform-provider-google](https://github.com/terraform-providers/terraform-provider-google) plugin v5.12+
- [Terraform Provider Beta for GCP](https://github.com/terraform-providers/terraform-provider-google-beta) plugin v5.12+

### Configure a Service Account

In order to execute this module you must have a Service Account with the following:

#### Roles

- Cloud SQL Admin: `roles/cloudsql.admin`
- Compute Network Admin: `roles/compute.networkAdmin`

### Enable APIs

In order to operate with the Service Account you must activate the following APIs on the project where the Service Account was created:

- Cloud SQL Admin API: `sqladmin.googleapis.com`

In order to use Private Service Access, required for using Private IPs, you must activate
the following APIs on the project where your VPC resides:

- Cloud SQL Admin API: `sqladmin.googleapis.com`
- Compute Engine API: `compute.googleapis.com`
- Service Networking API: `servicenetworking.googleapis.com`
- Cloud Resource Manager API: `cloudresourcemanager.googleapis.com`

#### Service Account Credentials

You can pass the service account credentials into this module by setting the following environment variables:

* `GOOGLE_CREDENTIALS`
* `GOOGLE_CLOUD_KEYFILE_JSON`
* `GCLOUD_KEYFILE_JSON`

See more [details](https://www.terraform.io/docs/providers/google/provider_reference.html#configuration-reference).

## Provision Instructions

This module has no root configuration. A module with no root configuration cannot be used directly.

Copy and paste into your Terraform configuration, insert the variables, and run terraform init :

For MySQL :
```
module "sql-db" {
  source  = "GoogleCloudPlatform/sql-db/google//modules/mysql"
  version = "~> 26.1"
}
```

or for PostgreSQL :

```
module "sql-db" {
  source  = "GoogleCloudPlatform/sql-db/google//modules/postgresql"
  version = "~> 22.0"
}
```

or for MSSQL Server :

```
module "sql-db" {
  source  = "GoogleCloudPlatform/sql-db/google//modules/mssql"
  version = "~> 22.0"
}
```


## Contributing

Refer to the [contribution guidelines](./CONTRIBUTING.md) for
information on contributing to this module.

# terraform-google-sql

terraform-google-sql makes it easy to create Google CloudSQL instance and implement high availability settings.
This module consists of the following submodules:

- [mysql](./modules/mysql)
- [postgresql](./modules/postgresql)

See more details in each module's README.

## Compatibility

This module is meant for use with Terraform 0.12. If you haven't
[upgraded](https://www.terraform.io/upgrade-guides/0-12.html)
and need a Terraform 0.11.x-compatible version of this module, the last
released version intended for Terraform 0.11.x is
[v1.2.0](https://registry.terraform.io/modules/GoogleCloudPlatform/sql-db/google/1.2.0).

## Upgrading

The current version is 3.X. The following guides are available to assist with upgrades:

- [1.X -> 2.0](./docs/upgrading_to_sql_db_2.0.0.md)
- [2.X -> 3.0](./docs/upgrading_to_sql_db_3.0.0.md)

## Root module

The root module has been deprecated. Please switch to using one of the submodules.

## Requirements

### Installation Dependencies

- [terraform](https://www.terraform.io/downloads.html) 0.12.x
- [terraform-provider-google](https://github.com/terraform-providers/terraform-provider-google) plugin v2.5.x

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

## Contributing

Refer to the [contribution guidelines](./CONTRIBUTING.md) for
information on contributing to this module.

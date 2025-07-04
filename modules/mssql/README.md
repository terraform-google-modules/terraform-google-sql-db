# terraform-google-sql for MSSQL Server

The following dependency must be available for SQL Server module:

## Usage
Functional examples are included in the [examples](../../examples/) directory. If you want to create an instance with failover replica and manage lifecycle of primary and secondary instance lifecycle using this module follow example in [mssql-failover-replica](../../examples/mssql-failover-replica/)

Basic usage of this module is as follows:

- Create simple Postgresql instance with read replica

```hcl
module "mssql" {
  source  = "terraform-google-modules/sql-db/google//modules/mssql"
  version = "~> 26.1"

  name                 = var.name
  random_instance_name = true
  project_id           = var.project_id
  user_name            = "simpleuser"
  user_password        = "foobar"

  deletion_protection = false

  sql_server_audit_config = var.sql_server_audit_config
}

```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| activation\_policy | The activation policy for the Cloud SQL instance. Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`. | `string` | `"ALWAYS"` | no |
| active\_directory\_config | Active domain that the SQL instance will join. | `map(string)` | `{}` | no |
| additional\_databases | A list of databases to be created in your cluster | <pre>list(object({<br>    name      = string<br>    charset   = string<br>    collation = string<br>  }))</pre> | `[]` | no |
| additional\_users | A list of users to be created in your cluster. A random password would be set for the user if the `random_password` variable is set. | <pre>list(object({<br>    name            = string<br>    password        = string<br>    random_password = bool<br>  }))</pre> | `[]` | no |
| availability\_type | The availability type for the Cloud SQL instance.This is only used to set up high availability for the MSSQL instance. Can be either `ZONAL` or `REGIONAL`. | `string` | `"ZONAL"` | no |
| backup\_configuration | The database backup configuration. | <pre>object({<br>    binary_log_enabled             = bool<br>    enabled                        = bool<br>    point_in_time_recovery_enabled = bool<br>    start_time                     = string<br>    transaction_log_retention_days = string<br>    retained_backups               = number<br>    retention_unit                 = string<br>  })</pre> | <pre>{<br>  "binary_log_enabled": null,<br>  "enabled": false,<br>  "point_in_time_recovery_enabled": null,<br>  "retained_backups": null,<br>  "retention_unit": null,<br>  "start_time": null,<br>  "transaction_log_retention_days": null<br>}</pre> | no |
| connector\_enforcement | Enforce that clients use the connector library | `bool` | `false` | no |
| create\_timeout | The optional timeout that is applied to limit long database creates. | `string` | `"30m"` | no |
| data\_cache\_enabled | Whether data cache is enabled for the instance. Defaults to false. Feature is only available for ENTERPRISE\_PLUS tier and supported database\_versions | `bool` | `false` | no |
| database\_flags | The database flags for the Cloud SQL. See [more details](https://cloud.google.com/sql/docs/sqlserver/flags) | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | `[]` | no |
| database\_version | The database version to use: SQLSERVER\_2017\_STANDARD, SQLSERVER\_2017\_ENTERPRISE, SQLSERVER\_2017\_EXPRESS, or SQLSERVER\_2017\_WEB | `string` | `"SQLSERVER_2017_STANDARD"` | no |
| db\_charset | The charset for the default database | `string` | `""` | no |
| db\_collation | The collation for the default database. Example: 'en\_US.UTF8' | `string` | `""` | no |
| db\_name | The name of the default database to create | `string` | `"default"` | no |
| delete\_timeout | The optional timeout that is applied to limit long database deletes. | `string` | `"30m"` | no |
| deletion\_protection | Used to block Terraform from deleting a SQL Instance. | `bool` | `true` | no |
| deletion\_protection\_enabled | Enables protection of an instance from accidental deletion protection across all surfaces (API, gcloud, Cloud Console and Terraform). | `bool` | `false` | no |
| deny\_maintenance\_period | The Deny Maintenance Period fields to prevent automatic maintenance from occurring during a 90-day time period. List accepts only one value. See [more details](https://cloud.google.com/sql/docs/sqlserver/maintenance) | <pre>list(object({<br>    end_date   = string<br>    start_date = string<br>    time       = string<br>  }))</pre> | `[]` | no |
| disk\_autoresize | Configuration to increase storage size. | `bool` | `true` | no |
| disk\_autoresize\_limit | The maximum size to which storage can be auto increased. | `number` | `0` | no |
| disk\_size | The disk size for the Cloud SQL instance. | `number` | `10` | no |
| disk\_type | The disk type for the Cloud SQL instance. | `string` | `"PD_SSD"` | no |
| edition | The edition of the instance, can be ENTERPRISE or ENTERPRISE\_PLUS. | `string` | `null` | no |
| enable\_dataplex\_integration | Enable database Dataplex integration | `bool` | `false` | no |
| enable\_default\_db | Enable or disable the creation of the default database | `bool` | `true` | no |
| enable\_default\_user | Enable or disable the creation of the default user | `bool` | `true` | no |
| encryption\_key\_name | The full path to the encryption key used for the CMEK disk encryption | `string` | `null` | no |
| follow\_gae\_application | A Google App Engine application whose zone to remain in. Must be in the same region as this instance. | `string` | `null` | no |
| insights\_config | The insights\_config settings for the database. | <pre>object({<br>    query_plans_per_minute  = optional(number, 5)<br>    query_string_length     = optional(number, 1024)<br>    record_application_tags = optional(bool, false)<br>    record_client_address   = optional(bool, false)<br>  })</pre> | `null` | no |
| instance\_type | The type of the instance. The supported values are SQL\_INSTANCE\_TYPE\_UNSPECIFIED, CLOUD\_SQL\_INSTANCE, ON\_PREMISES\_INSTANCE and READ\_REPLICA\_INSTANCE. Set to READ\_REPLICA\_INSTANCE when primary\_instance\_name is provided | `string` | `"CLOUD_SQL_INSTANCE"` | no |
| ip\_configuration | The ip configuration for the Cloud SQL instances. | <pre>object({<br>    authorized_networks = optional(list(map(string)), [])<br>    ipv4_enabled        = optional(bool)<br>    private_network     = optional(string)<br>    allocated_ip_range  = optional(string)<br>    ssl_mode            = optional(string)<br>  })</pre> | <pre>{<br>  "allocated_ip_range": null,<br>  "authorized_networks": [],<br>  "ipv4_enabled": true,<br>  "private_network": null,<br>  "ssl_mode": null<br>}</pre> | no |
| maintenance\_version | The current software version on the instance. This attribute can not be set during creation. Refer to available\_maintenance\_versions attribute to see what maintenance\_version are available for upgrade. When this attribute gets updated, it will cause an instance restart. Setting a maintenance\_version value that is older than the current one on the instance will be ignored | `string` | `null` | no |
| maintenance\_window\_day | The day of week (1-7) for the Cloud SQL maintenance. | `number` | `1` | no |
| maintenance\_window\_hour | The hour of day (0-23) maintenance window for the Cloud SQL maintenance. | `number` | `23` | no |
| maintenance\_window\_update\_track | The update track of maintenance window for the Cloud SQL maintenance.Can be either `canary` or `stable`. | `string` | `"canary"` | no |
| master\_instance\_name | Name of the master instance if this is a failover replica. Required for creating failover replica instance. Not needed for master instance. When removed, next terraform apply will promote this failover failover replica instance as master instance | `string` | `null` | no |
| module\_depends\_on | List of modules or resources this module depends on. | `list(any)` | `[]` | no |
| name | The name of the Cloud SQL instance | `string` | n/a | yes |
| pricing\_plan | The pricing plan for the Cloud SQL instance. | `string` | `"PER_USE"` | no |
| project\_id | The project ID to manage the Cloud SQL resources | `string` | n/a | yes |
| random\_instance\_name | Sets random suffix at the end of the Cloud SQL resource name | `bool` | `false` | no |
| region | The region of the Cloud SQL resources | `string` | `"us-central1"` | no |
| root\_password | MSSERVER password for the root user. If not set, a random one will be generated and available in the root\_password output variable. | `string` | `""` | no |
| secondary\_zone | The preferred zone for the read replica instance, it should be something like: `us-central1-a`, `us-east1-c`. | `string` | `null` | no |
| sql\_server\_audit\_config | SQL server audit config settings. | `map(string)` | `{}` | no |
| tier | The tier for the Cloud SQL instance. | `string` | `"db-custom-2-3840"` | no |
| time\_zone | The time zone for Cloud SQL instance. | `string` | `null` | no |
| update\_timeout | The optional timeout that is applied to limit long database updates. | `string` | `"30m"` | no |
| user\_labels | The key/value labels for the Cloud SQL instances. | `map(string)` | `{}` | no |
| user\_name | The name of the default user | `string` | `"default"` | no |
| user\_password | The password for the default user. If not set, a random one will be generated and available in the generated\_user\_password output variable. | `string` | `""` | no |
| zone | The zone for the Cloud SQL instance. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| additional\_users | List of maps of additional users and passwords |
| apphub\_service\_uri | Service URI in CAIS style to be used by Apphub. |
| generated\_user\_password | The auto generated default user password if not input password was provided |
| instance\_address | The IPv4 addesses assigned for the master instance |
| instance\_connection\_name | The connection name of the master instance to be used in connection strings |
| instance\_first\_ip\_address | The first IPv4 address of the addresses assigned. |
| instance\_name | The instance name for the master instance |
| instance\_self\_link | The URI of the master instance |
| instance\_server\_ca\_cert | The CA certificate information used to connect to the SQL instance via SSL |
| instance\_service\_account\_email\_address | The service account email address assigned to the master instance |
| primary | The `google_sql_database_instance` resource representing the primary instance |
| private\_address | The private IP address assigned for the master instance |
| root\_password | MSSERVER password for the root user. If not set, a random one will be generated and available in the root\_password output variable. |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Requirements

### Installation Dependencies

- [Terraform](https://www.terraform.io/downloads.html) >= 1.3.0
- [terraform-provider-google](https://github.com/terraform-providers/terraform-provider-google) plugin v5.12+
- [Terraform Provider Beta for GCP](https://github.com/terraform-providers/terraform-provider-google-beta) plugin v5.12+

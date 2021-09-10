# terraform-google-sql for MSSQL Server

The following dependency must be available for SQL Server module:

- [Terraform Provider Beta for GCP](https://github.com/terraform-providers/terraform-provider-google-beta) plugin v3.10

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| activation\_policy | The activation policy for the master instance.Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`. | `string` | `"ALWAYS"` | no |
| additional\_databases | A list of databases to be created in your cluster | <pre>list(object({<br>    name      = string<br>    charset   = string<br>    collation = string<br>  }))</pre> | `[]` | no |
| additional\_users | A list of users to be created in your cluster | <pre>list(object({<br>    name     = string<br>    password = string<br>  }))</pre> | `[]` | no |
| availability\_type | The availability type for the master instance.This is only used to set up high availability for the MSSQL instance. Can be either `ZONAL` or `REGIONAL`. | `string` | `"ZONAL"` | no |
| backup\_configuration | The database backup configuration. | <pre>object({<br>    binary_log_enabled             = bool<br>    enabled                        = bool<br>    point_in_time_recovery_enabled = bool<br>    start_time                     = string<br>    transaction_log_retention_days = string<br>    retained_backups               = number<br>    retention_unit                 = string<br>  })</pre> | <pre>{<br>  "binary_log_enabled": null,<br>  "enabled": false,<br>  "point_in_time_recovery_enabled": null,<br>  "retained_backups": null,<br>  "retention_unit": null,<br>  "start_time": null,<br>  "transaction_log_retention_days": null<br>}</pre> | no |
| create\_timeout | The optional timeout that is applied to limit long database creates. | `string` | `"15m"` | no |
| database\_flags | The database flags for the master instance. See [more details](https://cloud.google.com/sql/docs/sqlserver/flags) | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | `[]` | no |
| database\_version | The database version to use: SQLSERVER\_2017\_STANDARD, SQLSERVER\_2017\_ENTERPRISE, SQLSERVER\_2017\_EXPRESS, or SQLSERVER\_2017\_WEB | `string` | `"SQLSERVER_2017_STANDARD"` | no |
| db\_charset | The charset for the default database | `string` | `""` | no |
| db\_collation | The collation for the default database. Example: 'en\_US.UTF8' | `string` | `""` | no |
| db\_name | The name of the default database to create | `string` | `"default"` | no |
| delete\_timeout | The optional timeout that is applied to limit long database deletes. | `string` | `"30m"` | no |
| deletion\_protection | Used to block Terraform from deleting a SQL Instance. | `bool` | `true` | no |
| disk\_autoresize | Configuration to increase storage size. | `bool` | `true` | no |
| disk\_size | The disk size for the master instance. | `number` | `10` | no |
| disk\_type | The disk type for the master instance. | `string` | `"PD_SSD"` | no |
| encryption\_key\_name | The full path to the encryption key used for the CMEK disk encryption | `string` | `null` | no |
| ip\_configuration | The ip configuration for the master instances. | <pre>object({<br>    authorized_networks = list(map(string))<br>    ipv4_enabled        = bool<br>    private_network     = string<br>    require_ssl         = bool<br>  })</pre> | <pre>{<br>  "authorized_networks": [],<br>  "ipv4_enabled": true,<br>  "private_network": null,<br>  "require_ssl": null<br>}</pre> | no |
| maintenance\_window\_day | The day of week (1-7) for the master instance maintenance. | `number` | `1` | no |
| maintenance\_window\_hour | The hour of day (0-23) maintenance window for the master instance maintenance. | `number` | `23` | no |
| maintenance\_window\_update\_track | The update track of maintenance window for the master instance maintenance.Can be either `canary` or `stable`. | `string` | `"canary"` | no |
| module\_depends\_on | List of modules or resources this module depends on. | `list(any)` | `[]` | no |
| name | The name of the Cloud SQL resources | `string` | n/a | yes |
| pricing\_plan | The pricing plan for the master instance. | `string` | `"PER_USE"` | no |
| project\_id | The project ID to manage the Cloud SQL resources | `string` | n/a | yes |
| random\_instance\_name | Sets random suffix at the end of the Cloud SQL resource name | `bool` | `false` | no |
| region | The region of the Cloud SQL resources | `string` | `"us-central1"` | no |
| root\_password | MSSERVER password for the root user. If not set, a random one will be generated and available in the root\_password output variable. | `string` | `""` | no |
| tier | The tier for the master instance. | `string` | `"db-custom-2-3840"` | no |
| update\_timeout | The optional timeout that is applied to limit long database updates. | `string` | `"15m"` | no |
| user\_labels | The key/value labels for the master instances. | `map(string)` | `{}` | no |
| user\_name | The name of the default user | `string` | `"default"` | no |
| user\_password | The password for the default user. If not set, a random one will be generated and available in the generated\_user\_password output variable. | `string` | `""` | no |
| zone | The zone for the master instance. | `string` | `"us-central1-a"` | no |

## Outputs

| Name | Description |
|------|-------------|
| additional\_users | List of maps of additional users and passwords |
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

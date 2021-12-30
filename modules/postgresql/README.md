# terraform-google-sql for PostgreSQL

Note: CloudSQL provides [disk autoresize](https://cloud.google.com/sql/docs/mysql/instance-settings#automatic-storage-increase-2ndgen) feature which can cause a [Terraform configuration drift](https://www.hashicorp.com/blog/detecting-and-managing-drift-with-terraform) due to the value in `disk_size` variable, and hence any updates to this variable is ignored in the [Terraform lifecycle](https://www.terraform.io/docs/configuration/resources.html#ignore_changes).

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| activation\_policy | The activation policy for the master instance.Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`. | `string` | `"ALWAYS"` | no |
| additional\_databases | A list of databases to be created in your cluster | <pre>list(object({<br>    name      = string<br>    charset   = string<br>    collation = string<br>  }))</pre> | `[]` | no |
| additional\_users | A list of users to be created in your cluster | <pre>list(object({<br>    name     = string<br>    password = string<br>  }))</pre> | `[]` | no |
| availability\_type | The availability type for the master instance.This is only used to set up high availability for the PostgreSQL instance. Can be either `ZONAL` or `REGIONAL`. | `string` | `"ZONAL"` | no |
| backup\_configuration | The backup\_configuration settings subblock for the database setings | <pre>object({<br>    enabled                        = bool<br>    start_time                     = string<br>    location                       = string<br>    point_in_time_recovery_enabled = bool<br>    transaction_log_retention_days = string<br>    retained_backups               = number<br>    retention_unit                 = string<br>  })</pre> | <pre>{<br>  "enabled": false,<br>  "location": null,<br>  "point_in_time_recovery_enabled": false,<br>  "retained_backups": null,<br>  "retention_unit": null,<br>  "start_time": null,<br>  "transaction_log_retention_days": null<br>}</pre> | no |
| create\_timeout | The optional timout that is applied to limit long database creates. | `string` | `"15m"` | no |
| database\_flags | The database flags for the master instance. See [more details](https://cloud.google.com/sql/docs/postgres/flags) | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | `[]` | no |
| database\_version | The database version to use | `string` | n/a | yes |
| db\_charset | The charset for the default database | `string` | `""` | no |
| db\_collation | The collation for the default database. Example: 'en\_US.UTF8' | `string` | `""` | no |
| db\_name | The name of the default database to create | `string` | `"default"` | no |
| delete\_timeout | The optional timout that is applied to limit long database deletes. | `string` | `"15m"` | no |
| deletion\_protection | Used to block Terraform from deleting a SQL Instance. | `bool` | `true` | no |
| disk\_autoresize | Configuration to increase storage size. | `bool` | `true` | no |
| disk\_size | The disk size for the master instance. | `number` | `10` | no |
| disk\_type | The disk type for the master instance. | `string` | `"PD_SSD"` | no |
| enable\_default\_db | Enable or disable the creation of the default database | `bool` | `true` | no |
| enable\_default\_user | Enable or disable the creation of the default user | `bool` | `true` | no |
| encryption\_key\_name | The full path to the encryption key used for the CMEK disk encryption | `string` | `null` | no |
| iam\_user\_emails | A list of IAM users to be created in your cluster | `list(string)` | `[]` | no |
| insights\_config | The insights\_config settings for the database. | <pre>object({<br>    query_string_length     = number<br>    record_application_tags = bool<br>    record_client_address   = bool<br>  })</pre> | `null` | no |
| ip\_configuration | The ip configuration for the master instances. | <pre>object({<br>    authorized_networks = list(map(string))<br>    ipv4_enabled        = bool<br>    private_network     = string<br>    require_ssl         = bool<br>  })</pre> | <pre>{<br>  "authorized_networks": [],<br>  "ipv4_enabled": true,<br>  "private_network": null,<br>  "require_ssl": null<br>}</pre> | no |
| maintenance\_window\_day | The day of week (1-7) for the master instance maintenance. | `number` | `1` | no |
| maintenance\_window\_hour | The hour of day (0-23) maintenance window for the master instance maintenance. | `number` | `23` | no |
| maintenance\_window\_update\_track | The update track of maintenance window for the master instance maintenance.Can be either `canary` or `stable`. | `string` | `"canary"` | no |
| module\_depends\_on | List of modules or resources this module depends on. | `list(any)` | `[]` | no |
| name | The name of the Cloud SQL resources | `string` | n/a | yes |
| pricing\_plan | The pricing plan for the master instance. | `string` | `"PER_USE"` | no |
| project\_id | The project ID to manage the Cloud SQL resources | `string` | n/a | yes |
| random\_instance\_name | Sets random suffix at the end of the Cloud SQL resource name | `bool` | `false` | no |
| read\_replica\_deletion\_protection | Used to block Terraform from deleting replica SQL Instances. | `bool` | `false` | no |
| read\_replica\_name\_suffix | The optional suffix to add to the read instance name | `string` | `""` | no |
| read\_replicas | List of read replicas to create. Encryption key is required for replica in different region. For replica in same region as master set encryption\_key\_name = null | <pre>list(object({<br>    name            = string<br>    tier            = string<br>    zone            = string<br>    disk_type       = string<br>    disk_autoresize = bool<br>    disk_size       = string<br>    user_labels     = map(string)<br>    database_flags = list(object({<br>      name  = string<br>      value = string<br>    }))<br>    ip_configuration = object({<br>      authorized_networks = list(map(string))<br>      ipv4_enabled        = bool<br>      private_network     = string<br>      require_ssl         = bool<br>    })<br>    encryption_key_name = string<br>  }))</pre> | `[]` | no |
| region | The region of the Cloud SQL resources | `string` | `"us-central1"` | no |
| tier | The tier for the master instance. | `string` | `"db-f1-micro"` | no |
| update\_timeout | The optional timout that is applied to limit long database updates. | `string` | `"15m"` | no |
| user\_labels | The key/value labels for the master instances. | `map(string)` | `{}` | no |
| user\_name | The name of the default user | `string` | `"default"` | no |
| user\_password | The password for the default user. If not set, a random one will be generated and available in the generated\_user\_password output variable. | `string` | `""` | no |
| zone | The zone for the master instance, it should be something like: `us-central1-a`, `us-east1-c`. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| additional\_users | List of maps of additional users and passwords |
| generated\_user\_password | The auto generated default user password if not input password was provided |
| instance\_connection\_name | The connection name of the master instance to be used in connection strings |
| instance\_first\_ip\_address | The first IPv4 address of the addresses assigned. |
| instance\_ip\_address | The IPv4 address assigned for the master instance |
| instance\_name | The instance name for the master instance |
| instance\_self\_link | The URI of the master instance |
| instance\_server\_ca\_cert | The CA certificate information used to connect to the SQL instance via SSL |
| instance\_service\_account\_email\_address | The service account email address assigned to the master instance |
| instances | A list of all `google_sql_database_instance` resources we've created |
| primary | The `google_sql_database_instance` resource representing the primary instance |
| private\_ip\_address | The first private (PRIVATE) IPv4 address assigned for the master instance |
| public\_ip\_address | The first public (PRIMARY) IPv4 address assigned for the master instance |
| read\_replica\_instance\_names | The instance names for the read replica instances |
| replicas | A list of `google_sql_database_instance` resources representing the replicas |
| replicas\_instance\_connection\_names | The connection names of the replica instances to be used in connection strings |
| replicas\_instance\_first\_ip\_addresses | The first IPv4 addresses of the addresses assigned for the replica instances |
| replicas\_instance\_self\_links | The URIs of the replica instances |
| replicas\_instance\_server\_ca\_certs | The CA certificates information used to connect to the replica instances via SSL |
| replicas\_instance\_service\_account\_email\_addresses | The service account email addresses assigned to the replica instances |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

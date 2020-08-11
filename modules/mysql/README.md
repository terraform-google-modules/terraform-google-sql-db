# terraform-google-sql for MySQL

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| activation\_policy | The activation policy for the master instance. Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`. | string | `"ALWAYS"` | no |
| additional\_databases | A list of databases to be created in your cluster | object | `<list>` | no |
| additional\_users | A list of users to be created in your cluster | object | `<list>` | no |
| authorized\_gae\_applications | The list of authorized App Engine project names | list(string) | `<list>` | no |
| availability\_type | The availability type for the master instance. Can be either `REGIONAL` or `null`. | string | `"REGIONAL"` | no |
| backup\_configuration | The backup_configuration settings subblock for the database setings | object | `<map>` | no |
| create\_timeout | The optional timout that is applied to limit long database creates. | string | `"10m"` | no |
| database\_flags | List of Cloud SQL flags that are applied to the database server. See [more details](https://cloud.google.com/sql/docs/mysql/flags) | object | `<list>` | no |
| database\_version | The database version to use | string | n/a | yes |
| db\_charset | The charset for the default database | string | `""` | no |
| db\_collation | The collation for the default database. Example: 'utf8_general_ci' | string | `""` | no |
| db\_name | The name of the default database to create | string | `"default"` | no |
| delete\_timeout | The optional timout that is applied to limit long database deletes. | string | `"10m"` | no |
| disk\_autoresize | Configuration to increase storage size | bool | `"true"` | no |
| disk\_size | The disk size for the master instance | number | `"10"` | no |
| disk\_type | The disk type for the master instance. | string | `"PD_SSD"` | no |
| encryption\_key\_name | The full path to the encryption key used for the CMEK disk encryption | string | `"null"` | no |
| ip\_configuration | The ip_configuration settings subblock | object | `<map>` | no |
| maintenance\_window\_day | The day of week (1-7) for the master instance maintenance. | number | `"1"` | no |
| maintenance\_window\_hour | The hour of day (0-23) maintenance window for the master instance maintenance. | number | `"23"` | no |
| maintenance\_window\_update\_track | The update track of maintenance window for the master instance maintenance. Can be either `canary` or `stable`. | string | `"canary"` | no |
| module\_depends\_on | List of modules or resources this module depends on. | list(any) | `<list>` | no |
| name | The name of the Cloud SQL resources | string | n/a | yes |
| pricing\_plan | The pricing plan for the master instance. | string | `"PER_USE"` | no |
| project\_id | The project ID to manage the Cloud SQL resources | string | n/a | yes |
| random\_instance\_name | Sets random suffix at the end of the Cloud SQL resource name | bool | `"false"` | no |
| read\_replica\_name\_suffix | The optional suffix to add to the read instance name | string | `""` | no |
| read\_replicas | List of read replicas to create | object | `<list>` | no |
| region | The region of the Cloud SQL resources | string | `"us-central1"` | no |
| tier | The tier for the master instance. | string | `"db-n1-standard-1"` | no |
| update\_timeout | The optional timout that is applied to limit long database updates. | string | `"10m"` | no |
| user\_host | The host for the default user | string | `"%"` | no |
| user\_labels | The key/value labels for the master instances. | map(string) | `<map>` | no |
| user\_name | The name of the default user | string | `"default"` | no |
| user\_password | The password for the default user. If not set, a random one will be generated and available in the generated_user_password output variable. | string | `""` | no |
| zone | The zone for the master instance, it should be something like: `a`, `c`. | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| generated\_user\_password | The auto generated default user password if not input password was provided |
| instance\_connection\_name | The connection name of the master instance to be used in connection strings |
| instance\_first\_ip\_address | The first IPv4 address of the addresses assigned for the master instance. |
| instance\_ip\_address | The IPv4 address assigned for the master instance |
| instance\_name | The instance name for the master instance |
| instance\_self\_link | The URI of the master instance |
| instance\_server\_ca\_cert | The CA certificate information used to connect to the SQL instance via SSL |
| instance\_service\_account\_email\_address | The service account email address assigned to the master instance |
| private\_address | The private IP address assigned for the master instance |
| private\_ip\_address | The first private (PRIVATE) IPv4 address assigned for the master instance |
| public\_ip\_address | The first public (PRIMARY) IPv4 address assigned for the master instance |
| read\_replica\_instance\_names | The instance names for the read replica instances |
| replicas\_instance\_connection\_names | The connection names of the replica instances to be used in connection strings |
| replicas\_instance\_first\_ip\_addresses | The first IPv4 addresses of the addresses assigned for the replica instances |
| replicas\_instance\_self\_links | The URIs of the replica instances |
| replicas\_instance\_server\_ca\_certs | The CA certificates information used to connect to the replica instances via SSL |
| replicas\_instance\_service\_account\_email\_addresses | The service account email addresses assigned to the replica instances |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

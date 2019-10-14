# terraform-google-sql for PostgreSQL

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| activation\_policy | The activation policy for the master instance.Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`. | string | `"ALWAYS"` | no |
| additional\_databases | A list of databases to be created in your cluster | object | `<list>` | no |
| additional\_users | A list of users to be created in your cluster | object | `<list>` | no |
| authorized\_gae\_applications | The authorized gae applications for the Cloud SQL instances | list(string) | `<list>` | no |
| availability\_type | The availability type for the master instance.This is only used to set up high availability for the PostgreSQL instance. Can be either `ZONAL` or `REGIONAL`. | string | `"ZONAL"` | no |
| backup\_configuration | The backup_configuration settings subblock for the database setings | object | `<map>` | no |
| create\_timeout | The optional timout that is applied to limit long database creates. | string | `"10m"` | no |
| database\_flags | The database flags for the master instance. See [more details](https://cloud.google.com/sql/docs/mysql/flags) | object | `<list>` | no |
| database\_version | The database version to use | string | n/a | yes |
| db\_charset | The charset for the default database | string | `""` | no |
| db\_collation | The collation for the default database. Example: 'en_US.UTF8' | string | `""` | no |
| db\_name | The name of the default database to create | string | `"default"` | no |
| delete\_timeout | The optional timout that is applied to limit long database deletes. | string | `"10m"` | no |
| disk\_autoresize | Configuration to increase storage size. | bool | `"true"` | no |
| disk\_size | The disk size for the master instance. | string | `"10"` | no |
| disk\_type | The disk type for the master instance. | string | `"PD_SSD"` | no |
| ip\_configuration | The ip configuration for the master instances. | object | `<map>` | no |
| maintenance\_window\_day | The day of week (1-7) for the master instance maintenance. | number | `"1"` | no |
| maintenance\_window\_hour | The hour of day (0-23) maintenance window for the master instance maintenance. | number | `"23"` | no |
| maintenance\_window\_update\_track | The update track of maintenance window for the master instance maintenance.Can be either `canary` or `stable`. | string | `"canary"` | no |
| name | The name of the Cloud SQL resources | string | n/a | yes |
| peering\_completed | Optional. This is used to ensure that resources are created in the proper order when using private IPs and service network peering. | string | `""` | no |
| pricing\_plan | The pricing plan for the master instance. | string | `"PER_USE"` | no |
| project\_id | The project ID to manage the Cloud SQL resources | string | n/a | yes |
| read\_replica\_activation\_policy | The activation policy for the read replica instances.Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`. | string | `"ALWAYS"` | no |
| read\_replica\_availability\_type | The availability type for the read replica instances.This is only used to set up high availability for the PostgreSQL instances. Can be either `ZONAL` or `REGIONAL`. | string | `"ZONAL"` | no |
| read\_replica\_configuration | The replica configuration for use in all read replica instances. | object | `<map>` | no |
| read\_replica\_crash\_safe\_replication | The crash safe replication is to indicates when crash-safe replication flags are enabled. | bool | `"true"` | no |
| read\_replica\_database\_flags | The database flags for the read replica instances. See [more details](https://cloud.google.com/sql/docs/mysql/flags) | object | `<list>` | no |
| read\_replica\_disk\_autoresize | Configuration to increase storage size. | bool | `"true"` | no |
| read\_replica\_disk\_size | The disk size for the read replica instances. | number | `"10"` | no |
| read\_replica\_disk\_type | The disk type for the read replica instances. | string | `"PD_SSD"` | no |
| read\_replica\_ip\_configuration | The ip configuration for the read instances. | object | `<map>` | no |
| read\_replica\_maintenance\_window\_day | The day of week (1-7) for the read replica instances maintenance. | number | `"1"` | no |
| read\_replica\_maintenance\_window\_hour | The hour of day (0-23) maintenance window for the read replica instances maintenance. | number | `"23"` | no |
| read\_replica\_maintenance\_window\_update\_track | The update track of maintenance window for the read replica instances maintenance.Can be either `canary` or `stable`. | string | `"canary"` | no |
| read\_replica\_name\_suffix | The optional suffix to add to the read instance name | string | `""` | no |
| read\_replica\_pricing\_plan | The pricing plan for the read replica instances. | string | `"PER_USE"` | no |
| read\_replica\_replication\_type | The replication type for read replica instances. Can be one of ASYNCHRONOUS or SYNCHRONOUS. | string | `"SYNCHRONOUS"` | no |
| read\_replica\_size | The size of read replicas | number | `"0"` | no |
| read\_replica\_tier | The tier for the read replica instances. | string | `""` | no |
| read\_replica\_user\_labels | The key/value labels for the read replica instances. | map(string) | `<map>` | no |
| read\_replica\_zones | The zones for the read replica instancess, it should be something like: `a,b,c`. Given zones are used rotationally for creating read replicas. | string | `""` | no |
| region | The region of the Cloud SQL resources | string | `"us-central1"` | no |
| tier | The tier for the master instance. | string | `"db-f1-micro"` | no |
| update\_timeout | The optional timout that is applied to limit long database updates. | string | `"10m"` | no |
| user\_labels | The key/value labels for the master instances. | map(string) | `<map>` | no |
| user\_name | The name of the default user | string | `"default"` | no |
| user\_password | The password for the default user. If not set, a random one will be generated and available in the generated_user_password output variable. | string | `""` | no |
| zone | The zone for the master instance, it should be something like: `a`, `c`. | string | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| generated\_user\_password | The auto generated default user password if not input password was provided |
| instance\_address | The IPv4 addesses assigned for the master instance |
| instance\_connection\_name | The connection name of the master instance to be used in connection strings |
| instance\_first\_ip\_address | The first IPv4 address of the addresses assigned. |
| instance\_name | The instance name for the master instance |
| instance\_self\_link | The URI of the master instance |
| instance\_server\_ca\_cert | The CA certificate information used to connect to the SQL instance via SSL |
| instance\_service\_account\_email\_address | The service account email address assigned to the master instance |
| private\_address | The private IP address assigned for the master instance |
| read\_replica\_instance\_names | The instance names for the read replica instances |
| replicas\_instance\_connection\_names | The connection names of the replica instances to be used in connection strings |
| replicas\_instance\_ip\_addresses | The IPv4 addresses assigned for the replica instances |
| replicas\_instance\_self\_links | The URIs of the replica instances |
| replicas\_instance\_server\_ca\_certs | The CA certificates information used to connect to the replica instances via SSL |
| replicas\_instance\_service\_account\_email\_addresses | The service account email addresses assigned to the replica instances |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

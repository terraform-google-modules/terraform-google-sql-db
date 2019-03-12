# terraform-google-sql for PostgreSQL

[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| activation_policy | The activation policy for the master instance.Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`. | string | `ALWAYS` | no |
| additional_databases | A list of databases to be created in your cluster | list | `<list>` | no |
| additional_users | A list of users to be created in your cluster | list | `<list>` | no |
| authorized_gae_applications | The authorized gae applications for the Cloud SQL instances | list | `<list>` | no |
| availability_type | The availability type for the master instance.This is only used to set up high availability for the PostgreSQL instance. Can be either `ZONAL` or `REGIONAL`. | string | `ZONAL` | no |
| backup_configuration | The backup configuration block of the Cloud SQL resources This argument will be passed through the master instance directrly.<br><br>See [more details](https://www.terraform.io/docs/providers/google/r/sql_database_instance.html). | map | `<map>` | no |
| database_flags | The database flags for the master instance. See [more details](https://cloud.google.com/sql/docs/mysql/flags) | list | `<list>` | no |
| database_version | The database version to use | string | - | yes |
| db_charset | The charset for the default database | string | `` | no |
| db_collation | The collation for the default database. Example: 'en_US.UTF8' | string | `` | no |
| db_name | The name of the default database to create | string | `default` | no |
| disk_autoresize | Configuration to increase storage size. | string | `true` | no |
| disk_size | The disk size for the master instance. | string | `10` | no |
| disk_type | The disk type for the master instance. | string | `PD_SSD` | no |
| ip_configuration | The ip configuration for the master instances. | map | `<map>` | no |
| maintenance_window_day | The day of week (1-7) for the master instance maintenance. | string | `1` | no |
| maintenance_window_hour | The hour of day (0-23) maintenance window for the master instance maintenance. | string | `23` | no |
| maintenance_window_update_track | The update track of maintenance window for the master instance maintenance.Can be either `canary` or `stable`. | string | `canary` | no |
| name | The name of the Cloud SQL resources | string | - | yes |
| pricing_plan | The pricing plan for the master instance. | string | `PER_USE` | no |
| project_id | The project ID to manage the Cloud SQL resources | string | - | yes |
| read_replica_activation_policy | The activation policy for the read replica instances.Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`. | string | `ALWAYS` | no |
| read_replica_availability_type | The availability type for the read replica instances.This is only used to set up high availability for the PostgreSQL instances. Can be either `ZONAL` or `REGIONAL`. | string | `ZONAL` | no |
| read_replica_configuration | The replica configuration for use in read replica | map | `<map>` | no |
| read_replica_crash_safe_replication | The crash safe replication is to indicates when crash-safe replication flags are enabled. | string | `true` | no |
| read_replica_database_flags | The database flags for the read replica instances. See [more details](https://cloud.google.com/sql/docs/mysql/flags) | list | `<list>` | no |
| read_replica_disk_autoresize | Configuration to increase storage size. | string | `true` | no |
| read_replica_disk_size | The disk size for the read replica instances. | string | `10` | no |
| read_replica_disk_type | The disk type for the read replica instances. | string | `PD_SSD` | no |
| read_replica_ip_configuration | The ip configuration for the read instances. | map | `<map>` | no |
| read_replica_maintenance_window_day | The day of week (1-7) for the read replica instances maintenance. | string | `1` | no |
| read_replica_maintenance_window_hour | The hour of day (0-23) maintenance window for the read replica instances maintenance. | string | `23` | no |
| read_replica_maintenance_window_update_track | The update track of maintenance window for the read replica instances maintenance.Can be either `canary` or `stable`. | string | `canary` | no |
| read_replica_pricing_plan | The pricing plan for the read replica instances. | string | `PER_USE` | no |
| read_replica_replication_type | The replication type for read replica instances. Can be one of ASYNCHRONOUS or SYNCHRONOUS. | string | `SYNCHRONOUS` | no |
| read_replica_size | The size of read replicas | string | `0` | no |
| read_replica_tier | The tier for the read replica instances. | string | `` | no |
| read_replica_user_labels | The key/value labels for the read replica instances. | map | `<map>` | no |
| read_replica_zones | The zones for the read replica instancess, it should be something like: `a,b,c`. Given zones are used rotationally for creating read replicas. | string | `` | no |
| region | The region of the Cloud SQL resources | string | `us-central1` | no |
| tier | The tier for the master instance. | string | `db-f1-micro` | no |
| user_labels | The key/value labels for the master instances. | map | `<map>` | no |
| user_name | The name of the default user | string | `default` | no |
| user_password | The password for the default user. If not set, a random one will be generated and available in the generated_user_password output variable. | string | `` | no |
| zone | The zone for the master instance, it should be something like: `a`, `c`. | string | - | yes |

## Outputs

| Name | Description |
|------|-------------|
| generated_user_password | The auto generated default user password if not input password was provided |
| instance_address | The IPv4 addesses assigned for the master instance |
| instance_connection_name | The connection name of the master instance to be used in connection strings |
| instance_first_ip_address | The first IPv4 address of the addresses assigned. |
| instance_name | The instance name for the master instance |
| instance_self_link | The URI of the master instance |
| instance_server_ca_cert | The CA certificate information used to connect to the SQL instance via SSL |
| instance_service_account_email_address | The service account email address assigned to the master instance |
| read_replica_instance_names | The instance names for the read replica instances |
| replicas_instance_connection_names | The connection names of the replica instances to be used in connection strings |
| replicas_instance_ip_addresses | The IPv4 addresses assigned for the replica instances |
| replicas_instance_self_links | The URIs of the replica instances |
| replicas_instance_server_ca_certs | The CA certificates information used to connect to the replica instances via SSL |
| replicas_instance_service_account_email_addresses | The service account email addresses assigned to the replica instances |

[^]: (autogen_docs_end)
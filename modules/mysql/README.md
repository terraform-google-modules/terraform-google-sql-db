# terraform-google-sql for MySQL

[^]: (autogen_docs_start)

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| authorized_gae_applications | The authorized gae applications for the Cloud SQL instances | list | `<list>` | no |
| backup_configuration | The backup configuration block of the Cloud SQL resources This argument will be passed through the master instance directrly.<br><br>See [more details](https://www.terraform.io/docs/providers/google/r/sql_database_instance.html). | map | `<map>` | no |
| charset | The charset for the database | string | `utf8mb4` | no |
| collation | The collation for the database | string | `utf8mb4_general_ci` | no |
| database_version | The database version to use | string | - | yes |
| failover_replica | The failover replica settings of the Cloud SQL resources Following arguments are available:<br><br>tier - (Required) The tier for the failover replica instance.<br><br>zone - (Required) The zone for the failover replica instance, it should be something like: `a`, `c`.<br><br>activation_policy - (Optional) The activation policy for the failover replica instance. Defaults to `ALWAYS`. Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`.<br><br>authorized_gae_applications - (Optional) The list of authorized App Engine project names<br><br>crash_safe_replication (Optional) The crash safe replication is to indicates when crash-safe replication flags are enabled. Defaults to `true`.<br><br>disk_autoresize - (Optional) Configuration to increase storage size. Defaults to `true`.<br><br>disk_size - (Optional) The disk size for the failover replica instance. Defaults to `10`.<br><br>disk_type - (Opitional) The disk type for the failover replica instance. Defaults to `PD_SSD`.<br><br>pricing_plan - (Optional) The pricing plan for the failover replica instance. Defaults to `PER_USE`.<br><br>database_flags - (Optional) The database flags for the failover replica instance. See [more details](https://cloud.google.com/sql/docs/mysql/flags)<br><br>maintenance_window_day - (Optional) The day of week (1-7) for the failover replica instance maintenance.<br><br>maintenance_window_hour - (Optional) The hour of day (0-23) maintenance window for the failover replica instance maintenance.<br><br>maintenance_window_update_track - (Optional) The update track of maintenance window for the failover replica instance maintenance. Defaults to `canary`. Can be either `canary` or `stable`. | map | `<map>` | no |
| failover_replica_database_flags | The database flasgs to set on the failover replica instance | list | `<list>` | no |
| failover_replica_labels | The key/value labels for the failover replica instance. | map | `<map>` | no |
| ip_configuration | The ip configuration for the Cloud SQL instances. This argument will be passed through all instances as the settings.ip_configuration block. | map | `<map>` | no |
| master | The master settings of the Cloud SQL resources. Following arguments are available:<br><br>tier - (Required) The tier for the master instance.<br><br>zone - (Required) The zone for the master instance, it should be something like: `a`, `c`.<br><br>activation_policy - (Optional) The activation policy for the master instance. Defaults to `ALWAYS`. Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`.<br><br>authorized_gae_applications - (Optional) The list of authorized App Engine project names<br><br>disk_autoresize - (Optional) Configuration to increase storage size. Defaults to `true`.<br><br>disk_size - (Optional) The disk size for the master instance. Defaults to `10`.<br><br>disk_type - (Opitional) The disk type for the master instance. Defaults to `PD_SSD`.<br><br>pricing_plan - (Optional) The pricing plan for the master instance. Defaults to `PER_USE`.<br><br>database_flags - (Optional) The database flags for the master instance. See [more details](https://cloud.google.com/sql/docs/mysql/flags)<br><br>maintenance_window_day - (Optional) The day of week (1-7) for the master instance maintenance.<br><br>maintenance_window_hour - (Optional) The hour of day (0-23) maintenance window for the master instance maintenance.<br><br>maintenance_window_update_track - (Optional) The update track of maintenance window for the master instance maintenance. Defaults to `canary`. Can be either `canary` or `stable`. | map | `<map>` | no |
| master_database_flags | The database flasgs to set on the master instance | list | `<list>` | no |
| master_labels | The key/value labels for the master instances. | map | `<map>` | no |
| name | The name of the Cloud SQL resources | string | - | yes |
| project_id | The project ID to manage the Cloud SQL resources | string | - | yes |
| read_replica | The read replica settings of the Cloud SQL resources Following arguments are available:<br><br>tier - (Required) The tier for the read replica instances.<br><br>zones - (Required) The zones for the read replica instancess, it should be something like: `a,b,c`. Given zones are used rotationally for creating read replicas.<br><br>activation_policy - (Optional) The activation policy for the read replica instances. Defaults to `ALWAYS`. Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`.<br><br>authorized_gae_applications - (Optional) The list of authorized App Engine project names<br><br>crash_safe_replication (Optional) The crash safe replication is to indicates when crash-safe replication flags are enabled. Defaults to `true`.<br><br>disk_autoresize - (Optional) Configuration to increase storage size. Defaults to `true`.<br><br>disk_size - (Optional) The disk size for the read replica instances. Defaults to `10`.<br><br>disk_type - (Opitional) The disk type for the read replica instances. Defaults to `PD_SSD`.<br><br>pricing_plan - (Optional) The pricing plan for the read replica instances. Defaults to `PER_USE`.<br><br>database_flags - (Optional) The database flags for the read replica instances. See [more details](https://cloud.google.com/sql/docs/mysql/flags)<br><br>maintenance_window_day - (Optional) The day of week (1-7) for the read replica instances maintenance.<br><br>maintenance_window_hour - (Optional) The hour of day (0-23) maintenance window for the read replica instances maintenance.<br><br>maintenance_window_update_track - (Optional) The update track of maintenance window for the read replica instances maintenance. Defaults to `canary`. Can be either `canary` or `stable`. | map | `<map>` | no |
| read_replica_database_flags | The database flasgs to set on the read replica instances | list | `<list>` | no |
| read_replica_labels | The key/value labels for the read replica instances. | map | `<map>` | no |
| region | The region of the Cloud SQL resources | string | - | yes |
| replica_configuration | The replica configuration for use in read replica and failover replica | map | `<map>` | no |
| users | The list of users on the database | list | `<list>` | no |

## Outputs

| Name | Description |
|------|-------------|
| failover-replica_instance_connection_name | - |
| failover-replica_instance_first_ip_address | Failover Replicas |
| failover-replica_instance_self_link | - |
| failover-replica_instance_server_ca_cert | - |
| failover-replica_instance_service_account_email_address | - |
| master_instance_connection_name | - |
| master_instance_first_ip_address | Master |
| master_instance_self_link | - |
| master_instance_server_ca_cert | - |
| master_instance_service_account_email_address | - |
| replicas_instance_connection_names | - |
| replicas_instance_first_ip_addresses | Replicas |
| replicas_instance_self_links | - |
| replicas_instance_server_ca_certs | - |
| replicas_instance_service_account_email_addresses | - |

[^]: (autogen_docs_end)
# terraform-google-sql for PostgreSQL

Note: CloudSQL provides [disk autoresize](https://cloud.google.com/sql/docs/mysql/instance-settings#automatic-storage-increase-2ndgen) feature which can cause a [Terraform configuration drift](https://www.hashicorp.com/blog/detecting-and-managing-drift-with-terraform) due to the value in `disk_size` variable, and hence any updates to this variable is ignored in the [Terraform lifecycle](https://www.terraform.io/docs/configuration/resources.html#ignore_changes).


## Usage
Functional examples are included in the [examples](../../examples/) directory. If you want to create an instance with failover replica and manage lifecycle of primary and secondary instance lifecycle using this module follow example in [postgresql-with-cross-region-failover](../../examples/postgresql-with-cross-region-failover/)

Basic usage of this module is as follows:

- Create simple Postgresql instance with read replica

```hcl
module "pg" {
  source  = "terraform-google-modules/sql-db/google//modules/postgresql"
  version = "~> 20.2"

  name                 = var.pg_ha_name
  random_instance_name = true
  project_id           = var.project_id
  database_version     = "POSTGRES_9_6"
  region               = "us-central1"

  // Master configurations
  tier                            = "db-custom-1-3840"
  zone                            = "us-central1-c"
  availability_type               = "REGIONAL"
  maintenance_window_day          = 7
  maintenance_window_hour         = 12
  maintenance_window_update_track = "stable"

  deletion_protection = false

  database_flags = [{ name = "autovacuum", value = "off" }]

  user_labels = {
    foo = "bar"
  }

  ip_configuration = {
    ipv4_enabled       = true
    require_ssl        = true
    private_network    = null
    allocated_ip_range = null
    authorized_networks = [
      {
        name  = "${var.project_id}-cidr"
        value = var.pg_ha_external_ip_range
      },
    ]
  }

  backup_configuration = {
    enabled                        = true
    start_time                     = "20:55"
    location                       = null
    point_in_time_recovery_enabled = false
    transaction_log_retention_days = null
    retained_backups               = 365
    retention_unit                 = "COUNT"
  }

  // Read replica configurations
  read_replica_name_suffix = "-test-ha"
  read_replicas = [
    {
      name                  = "0"
      zone                  = "us-central1-a"
      availability_type     = "REGIONAL"
      tier                  = "db-custom-1-3840"
      ip_configuration      = local.read_replica_ip_configuration
      database_flags        = [{ name = "autovacuum", value = "off" }]
      disk_autoresize       = null
      disk_autoresize_limit = null
      disk_size             = null
      disk_type             = "PD_HDD"
      user_labels           = { bar = "baz" }
      encryption_key_name   = null
    },
  ]

  db_name      = var.pg_ha_name
  db_charset   = "UTF8"
  db_collation = "en_US.UTF8"

  additional_databases = [
    {
      name      = "${var.pg_ha_name}-additional"
      charset   = "UTF8"
      collation = "en_US.UTF8"
    },
  ]

  user_name     = "tftest"
  user_password = "foobar"

  additional_users = [
    {
      name            = "tftest2"
      password        = "abcdefg"
      host            = "localhost"
      random_password = false
    },
    {
      name            = "tftest3"
      password        = "abcdefg"
      host            = "localhost"
      random_password = false
    },
  ]
}

```
<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| activation\_policy | The activation policy for the Cloud SQL instance.Can be either `ALWAYS`, `NEVER` or `ON_DEMAND`. | `string` | `"ALWAYS"` | no |
| additional\_databases | A list of databases to be created in your cluster | <pre>list(object({<br>    name      = string<br>    charset   = string<br>    collation = string<br>  }))</pre> | `[]` | no |
| additional\_users | A list of users to be created in your cluster. A random password would be set for the user if the `random_password` variable is set. | <pre>list(object({<br>    name            = string<br>    password        = string<br>    random_password = bool<br>  }))</pre> | `[]` | no |
| availability\_type | The availability type for the Cloud SQL instance.This is only used to set up high availability for the PostgreSQL instance. Can be either `ZONAL` or `REGIONAL`. | `string` | `"ZONAL"` | no |
| backup\_configuration | The backup\_configuration settings subblock for the database setings | <pre>object({<br>    enabled                        = optional(bool, false)<br>    start_time                     = optional(string)<br>    location                       = optional(string)<br>    point_in_time_recovery_enabled = optional(bool, false)<br>    transaction_log_retention_days = optional(string)<br>    retained_backups               = optional(number)<br>    retention_unit                 = optional(string)<br>  })</pre> | `{}` | no |
| connector\_enforcement | Enforce that clients use the connector library | `bool` | `false` | no |
| create\_timeout | The optional timout that is applied to limit long database creates. | `string` | `"30m"` | no |
| data\_cache\_enabled | Whether data cache is enabled for the instance. Defaults to false. Feature is only available for ENTERPRISE\_PLUS tier and supported database\_versions | `bool` | `false` | no |
| database\_deletion\_policy | The deletion policy for the database. Setting ABANDON allows the resource to be abandoned rather than deleted. This is useful for Postgres, where databases cannot be deleted from the API if there are users other than cloudsqlsuperuser with access. Possible values are: "ABANDON". | `string` | `null` | no |
| database\_flags | The database flags for the Cloud SQL instance. See [more details](https://cloud.google.com/sql/docs/postgres/flags) | <pre>list(object({<br>    name  = string<br>    value = string<br>  }))</pre> | `[]` | no |
| database\_integration\_roles | The roles required by default database instance service account for integration with GCP services | `list(string)` | `[]` | no |
| database\_version | The database version to use | `string` | n/a | yes |
| db\_charset | The charset for the default database | `string` | `""` | no |
| db\_collation | The collation for the default database. Example: 'en\_US.UTF8' | `string` | `""` | no |
| db\_name | The name of the default database to create | `string` | `"default"` | no |
| delete\_timeout | The optional timout that is applied to limit long database deletes. | `string` | `"30m"` | no |
| deletion\_protection | Used to block Terraform from deleting a SQL Instance. | `bool` | `true` | no |
| deletion\_protection\_enabled | Enables protection of an Cloud SQL instance from accidental deletion across all surfaces (API, gcloud, Cloud Console and Terraform). | `bool` | `false` | no |
| deny\_maintenance\_period | The Deny Maintenance Period fields to prevent automatic maintenance from occurring during a 90-day time period. List accepts only one value. See [more details](https://cloud.google.com/sql/docs/postgres/maintenance) | <pre>list(object({<br>    end_date   = string<br>    start_date = string<br>    time       = string<br>  }))</pre> | `[]` | no |
| disk\_autoresize | Configuration to increase storage size. | `bool` | `true` | no |
| disk\_autoresize\_limit | The maximum size to which storage can be auto increased. | `number` | `0` | no |
| disk\_size | The disk size for the Cloud SQL instance. | `number` | `10` | no |
| disk\_type | The disk type for the Cloud SQL instance. | `string` | `"PD_SSD"` | no |
| edition | The edition of the Cloud SQL instance, can be ENTERPRISE or ENTERPRISE\_PLUS. | `string` | `null` | no |
| enable\_default\_db | Enable or disable the creation of the default database | `bool` | `true` | no |
| enable\_default\_user | Enable or disable the creation of the default user | `bool` | `true` | no |
| enable\_google\_ml\_integration | Enable database ML integration | `bool` | `false` | no |
| enable\_random\_password\_special | Enable special characters in generated random passwords. | `bool` | `false` | no |
| encryption\_key\_name | The full path to the encryption key used for the CMEK disk encryption | `string` | `null` | no |
| follow\_gae\_application | A Google App Engine application whose zone to remain in. Must be in the same region as this instance. | `string` | `null` | no |
| iam\_users | A list of IAM users to be created in your CloudSQL instance | <pre>list(object({<br>    id    = string,<br>    email = string<br>  }))</pre> | `[]` | no |
| insights\_config | The insights\_config settings for the database. | <pre>object({<br>    query_plans_per_minute  = optional(number, 5)<br>    query_string_length     = optional(number, 1024)<br>    record_application_tags = optional(bool, false)<br>    record_client_address   = optional(bool, false)<br>  })</pre> | `null` | no |
| instance\_type | The type of the instance. The supported values are SQL\_INSTANCE\_TYPE\_UNSPECIFIED, CLOUD\_SQL\_INSTANCE, ON\_PREMISES\_INSTANCE and READ\_REPLICA\_INSTANCE. Set to READ\_REPLICA\_INSTANCE if master\_instance\_name value is provided | `string` | `"CLOUD_SQL_INSTANCE"` | no |
| ip\_configuration | The ip configuration for the Cloud SQL instances. | <pre>object({<br>    authorized_networks                           = optional(list(map(string)), [])<br>    ipv4_enabled                                  = optional(bool, true)<br>    private_network                               = optional(string)<br>    require_ssl                                   = optional(bool)<br>    ssl_mode                                      = optional(string)<br>    allocated_ip_range                            = optional(string)<br>    enable_private_path_for_google_cloud_services = optional(bool, false)<br>    psc_enabled                                   = optional(bool, false)<br>    psc_allowed_consumer_projects                 = optional(list(string), [])<br>  })</pre> | `{}` | no |
| maintenance\_window\_day | The day of week (1-7) for the Cloud SQL instance maintenance. | `number` | `1` | no |
| maintenance\_window\_hour | The hour of day (0-23) maintenance window for the Cloud SQL instance maintenance. | `number` | `23` | no |
| maintenance\_window\_update\_track | The update track of maintenance window for the Cloud SQL instance maintenance.Can be either `canary` or `stable`. | `string` | `"canary"` | no |
| master\_instance\_name | Name of the master instance if this is a failover replica. Required for creating failover replica instance. Not needed for master instance. When removed, next terraform apply will promote this failover failover replica instance as master instance | `string` | `null` | no |
| module\_depends\_on | List of modules or resources this module depends on. | `list(any)` | `[]` | no |
| name | The name of the Cloud SQL instance | `string` | n/a | yes |
| password\_validation\_policy\_config | The password validation policy settings for the database instance. | <pre>object({<br>    min_length                  = optional(number)<br>    complexity                  = optional(string)<br>    reuse_interval              = optional(number)<br>    disallow_username_substring = optional(bool)<br>    password_change_interval    = optional(string)<br>  })</pre> | `null` | no |
| pricing\_plan | The pricing plan for the Cloud SQL instance. | `string` | `"PER_USE"` | no |
| project\_id | The project ID to manage the Cloud SQL resources | `string` | n/a | yes |
| random\_instance\_name | Sets random suffix at the end of the Cloud SQL resource name | `bool` | `false` | no |
| read\_replica\_deletion\_protection | Used to block Terraform from deleting replica SQL Instances. | `bool` | `false` | no |
| read\_replica\_deletion\_protection\_enabled | Enables protection of replica instance from accidental deletion across all surfaces (API, gcloud, Cloud Console and Terraform). | `bool` | `false` | no |
| read\_replica\_name\_suffix | The optional suffix to add to the read instance name | `string` | `""` | no |
| read\_replicas | List of read replicas to create. Encryption key is required for replica in different region. For replica in same region as master set encryption\_key\_name = null | <pre>list(object({<br>    name                  = string<br>    name_override         = optional(string)<br>    tier                  = optional(string)<br>    edition               = optional(string)<br>    availability_type     = optional(string)<br>    zone                  = optional(string)<br>    disk_type             = optional(string)<br>    disk_autoresize       = optional(bool)<br>    disk_autoresize_limit = optional(number)<br>    disk_size             = optional(string)<br>    user_labels           = map(string)<br>    database_flags = optional(list(object({<br>      name  = string<br>      value = string<br>    })), [])<br>    insights_config = optional(object({<br>      query_plans_per_minute  = optional(number, 5)<br>      query_string_length     = optional(number, 1024)<br>      record_application_tags = optional(bool, false)<br>      record_client_address   = optional(bool, false)<br>    }), null)<br>    ip_configuration = object({<br>      authorized_networks                           = optional(list(map(string)), [])<br>      ipv4_enabled                                  = optional(bool)<br>      private_network                               = optional(string, )<br>      require_ssl                                   = optional(bool)<br>      ssl_mode                                      = optional(string)<br>      allocated_ip_range                            = optional(string)<br>      enable_private_path_for_google_cloud_services = optional(bool, false)<br>      psc_enabled                                   = optional(bool, false)<br>      psc_allowed_consumer_projects                 = optional(list(string), [])<br>    })<br>    encryption_key_name = optional(string)<br>    data_cache_enabled  = optional(bool)<br>  }))</pre> | `[]` | no |
| region | The region of the Cloud SQL resources | `string` | `"us-central1"` | no |
| root\_password | Initial root password during creation | `string` | `null` | no |
| secondary\_zone | The preferred zone for the replica instance, it should be something like: `us-central1-a`, `us-east1-c`. | `string` | `null` | no |
| tier | The tier for the Cloud SQL instance. | `string` | `"db-f1-micro"` | no |
| update\_timeout | The optional timout that is applied to limit long database updates. | `string` | `"30m"` | no |
| user\_deletion\_policy | The deletion policy for the user. Setting ABANDON allows the resource to be abandoned rather than deleted. This is useful for Postgres, where users cannot be deleted from the API if they have been granted SQL roles. Possible values are: "ABANDON". | `string` | `null` | no |
| user\_labels | The key/value labels for the Cloud SQL instances. | `map(string)` | `{}` | no |
| user\_name | The name of the default user | `string` | `"default"` | no |
| user\_password | The password for the default user. If not set, a random one will be generated and available in the generated\_user\_password output variable. | `string` | `""` | no |
| zone | The zone for the Cloud SQL instance, it should be something like: `us-central1-a`, `us-east1-c`. | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| additional\_users | List of maps of additional users and passwords |
| dns\_name | DNS name of the instance endpoint |
| env\_vars | Exported environment variables |
| generated\_user\_password | The auto generated default user password if not input password was provided |
| iam\_users | The list of the IAM users with access to the CloudSQL instance |
| instance\_connection\_name | The connection name of the master instance to be used in connection strings |
| instance\_first\_ip\_address | The first IPv4 address of the addresses assigned. |
| instance\_ip\_address | The IPv4 address assigned for the master instance |
| instance\_name | The instance name for the master instance |
| instance\_psc\_attachment | The psc\_service\_attachment\_link created for the master instance |
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

## Requirements

### Installation Dependencies

- [Terraform](https://www.terraform.io/downloads.html) >= 1.3.0
- [terraform-provider-google](https://github.com/terraform-providers/terraform-provider-google) plugin v5.25+
- [Terraform Provider Beta for GCP](https://github.com/terraform-providers/terraform-provider-google-beta) plugin v5.25+

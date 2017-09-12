# Cloud SQL Database Module

Modular Cloud SQL database instance for Terraform.

See the Cloud SQL documentation for details: https://cloud.google.com/sql

## Usage

```ruby
module "mysql-db" {
  source           = "github.com/GoogleCloudPlatform/terraform-google-sql-db"
  name             = "example-mysql-${random_id.name.hex}"
  database_version = "MYSQL_5_6"
}
```

### Input variables

- `project` (optional): The project to deploy to, if not set the default provider project is used.
- `region` (optional): Region for cloud resources. Default is `us-central1`.
- `name` (required): Name for the database instance. Must be unique and cannot be reused for up to one week.
- `database_version` (optional): The version of of the database. For example, `MYSQL_5_6` or `POSTGRES_9_6`. Default is `MYSQL_5_6`.
- `tier` (optional): The machine tier (First Generation) or type (Second Generation). See this page for supported tiers and pricing: https://cloud.google.com/sql/pricing. Default is `db-f1-micro`.
- `db_name` (optional): Name of the default database to create. Default is `default`.
- `db_charset` (optional): The charset for the default database. Default is `""` which will revert to the default for the database version.
- `db_collation` (optional): The collation for the default database. Example for MySQL databases: 'utf8', and Postgres: 'en_US.UTF8'". Default is `""` which will revert to the default for the database version.
- `user_name` (optional): The name of the default user. Default is `default`.
- `user_host` (optional): The host for the default user. Default is `"%"`. Set to `""` if database version is PostgreSQL.
- `user_password` (optional): "The password for the default user. If not set, a random one will be generated and available in the `generated_user_password` output variable.
- `activation_policy` (optional): This specifies when the instance should be active. Can be either `ALWAYS`, `NEVER` or `ON_DEMAND.`
- `authorized_gae_applications` (optional): A list of Google App Engine (GAE) project names that are allowed to access this instance. Default is `[]`.
- `disk_autoresize` (optional): Second Generation only. Configuration to increase storage size automatically. Default is `true`.
- `disk_size` (optional): Second generation only. The size of data disk, in GB. Size of a running instance cannot be reduced but can be increased. Default is `10`.
- `disk_type` (optional): Second generation only. The type of data disk: `PD_SSD` or `PD_HDD`. Default is `PD_SSD`.
- `pricing_plan` (optional): First generation only. Pricing plan for this instance, can be one of `PER_USE` or `PACKAGE`. Default is `PER_USE`.
- `replication_type` (optional): Replication type for this instance, can be one of `ASYNCHRONOUS` or `SYNCHRONOUS`. Default is `SYNCHRONOUS`.
- `backup_configuration` (optional): The backup_configuration settings subblock for the database setings. Default is `{}`
- `ip_configuration` (optional): The ip_configuration settings subblock. Default is `[{}]`.
- `location_preference` (optional): The location_preference settings subblock. Default is `[]`.
- `maintenance_window` (optional): The maintenance_window settings subblock. Defualt is `[]`.
- `replica_configuration` (optional): The optional replica_configuration block for the database instance. Default is `[]`.

### Output variables 

- `instance_name`: The name of the database instance.
- `instance_address`: The IPv4 address of the master database instnace.
- `instance_address_time_to_retire`: The time the master instance IP address will be reitred. RFC 3339 format.
- `self_link`: Self link to the master instance.
- `generated_user_password`: The auto generated default user password if no input password was provided.

## Resources created

- [`google_sql_database_instance.master`](https://www.terraform.io/docs/providers/google/r/sql_database_instance.html): The master database instance.
- [`google_sql_database.default`](https://www.terraform.io/docs/providers/google/r/sql_database.html): The default database created. 
- [`google_sql_user.default`](https://www.terraform.io/docs/providers/google/r/sql_user.html): The default user created.

# Cloud SQL Database Module

Modular Cloud SQL database instance for Terraform.

See the Cloud SQL documentation for details: https://cloud.google.com/sql

## Usage

```ruby
module "mysql-db" {
  source           = "GoogleCloudPlatform/sql-db/google"
  name             = "example-mysql-${random_id.name.hex}"
  database_version = "MYSQL_5_6"
}
```

## Resources created

- [`google_sql_database_instance.master`](https://www.terraform.io/docs/providers/google/r/sql_database_instance.html): The master database instance.
- [`google_sql_database.default`](https://www.terraform.io/docs/providers/google/r/sql_database.html): The default database created. 
- [`google_sql_user.default`](https://www.terraform.io/docs/providers/google/r/sql_user.html): The default user created.

# Upgrading to SQL DB 2.0.0

The 2.0.0 release of SQL DB is a backward incompatible release. This
incompatibility affects any configuration which uses the root module.

## Instructions

Prior to the 1.1.0 release, the root module was the only mechanism to
configure databases:

```hcl
module "sql_db_mysql" {
  source  = "GoogleCloudPlatform/sql-db/google"
  version = "1.0.0"

  database_version = "MYSQL_5_6"
  name             = "mysql-example"
  project          = "example-project"
  region           = "us-central1"
}

module "sql_db_postgresql" {
  source  = "GoogleCloudPlatform/sql-db/google"
  version = "1.0.0"

  database_version = "POSTGRES_9_6"
  name             = "postgresql-examlpe"
  project          = "example-project"
  region           = "us-central1"
}
```

With the 1.1.0 release, submodules were added for each type of
database. As of the 2.0.0 release, the root module has been removed so
the submodules must be used:

```diff
 module "sql_db_mysql" {
-  source  = "GoogleCloudPlatform/sql-db/google"
+  source  = "GoogleCloudPlatform/sql-db/google//modules/mysql"
-  version = "1.0.0"
+  version = "~> 2.0"

   database_version = "MYSQL_5_6"
   name             = "mysql-example"
-  project          = "example-project"
+  project_id       = "example-project"
   region           = "us-central1"
+  zone             = "us-central1-a"
 }

 module "sql_db_postgresql" {
-  source  = "GoogleCloudPlatform/sql-db/google"
+  source  = "GoogleCloudPlatform/sql-db/google//modules/postgresql"
-  version = "1.0.0"
+  version = "~> 2.0"

   database_version = "POSTGRES_9_6"
   name             = "postgresql-example"
-  project          = "example-project"
+  project_id       = "example-project"
   region           = "us-central1"
+  zone             = "us-central1-a"
 }
```

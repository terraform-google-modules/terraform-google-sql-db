# Upgrading to SQL DB 14.0.0

The 14.0.0 release of SQL DB is a backward incompatible release. This incompatibility affects `postgresql` submodule that uses IAM authentication. It also affects `additional_users` variable in all 3 modules.

## Migration Instructions

### Removed cloudsql.instanceUser iam_binding

Prior to the 14.0.0 release, in `postgresql` submodule with IAM athentication, for every `iam_user_emails` there was  `cloudsql.instanceUser` IAM binding created automatically. However keeping IAM binding inside the module can cause an unintentional outage in some cases (see[#381](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/381))

```hcl
module "pg" {
  source  = "GoogleCloudPlatform/sql-db/google//modules/postgresql"
  version = "~> 13.0"

  name                 = "test"
  database_version     = "POSTGRES_14"
  project_id           = var.project_id
  zone                 = "europe-west1-b"
  region               = "europe-west1"
  tier                 = "db-custom-1-3840"

  database_flags = [
    {
      name  = "cloudsql.iam_authentication"
      value = "on"
    }
  ]

  iam_user_emails = [
    "test-sa@${var.project_id}.iam.gserviceaccount.com",
    "test-sa-two@${var.project_id}.iam.gserviceaccount.com"
  ]
}
```

With the 14.0.0 release, the `google_project_iam_member` resource was removed from the module. Respective IAM binding for `cloudsql.instanceUser` should be created and managed outside of the module.

```diff
module "pg" {
  source  = "GoogleCloudPlatform/sql-db/google//modules/postgresql"
- version = "~> 13.0"
+ version = "~> 14.0"

  name                 = "test"
  database_version     = "POSTGRES_14"
  project_id           = var.project_id
  zone                 = "europe-west1-b"
  region               = "europe-west1"
  tier                 = "db-custom-1-3840"

  database_flags = [
    {
      name  = "cloudsql.iam_authentication"
      value = "on"
    }
  ]

  iam_user_emails = [
    "test-sa@${var.project_id}.iam.gserviceaccount.com",
    "john.doe@gmail.com"
  ]
}

+ locals {
+   iam_users = [for iu in module.pg.iam_user_emails : {
+     email         = iu,
+     is_account_sa = trimsuffix(iu, "gserviceaccount.com") == iu ? false : true
+   }]
+ }
+
+ resource "google_project_iam_member" "iam_binding" {
+   for_each = {
+     for iu in local.iam_users :
+     "${iu.email} ${iu.is_account_sa}" => iu
+   }
+   project = var.project_id
+   role    = "roles/cloudsql.instanceUser"
+   member = each.value.is_account_sa ? (
+     "serviceAccount:${each.value.email}"
+     ) : (
+     "user:${each.value.email}"
+   )
+ }
```

To gracefully and safely migrate, recommend way is to use `terraform state mv`:

```sh
terraform state mv \
'module.pg.google_project_iam_member.iam_binding["test-sa@${var.project_id}.iam.gserviceaccount.com true"]' \
'google_project_iam_member.iam_binding["test-sa@${var.project_id}.iam.gserviceaccount.com true"]'
terraform state mv \
'module.pg.google_project_iam_member.iam_binding["john.doe@gmail.com false"]' \
'google_project_iam_member.iam_binding["john.doe@gmail.com false"]'
```

[OPTIONAL] To automatically generate `terraform state mv` commands from above, you can use this simple script:

```sh
#!/usr/bin/env bash
#########################################################
# The script outputs prepared terraform state mv commands
# Based on the sql_module_name variable

sql_module_name="module.pg"
IFS='
'
for n in $(terraform state list | grep ''${sql_module_name}'.google_project_iam_member.iam_binding'); do
  iam_binding=$(echo $n | sed "s/${sql_module_name}\.//g")
  echo "terraform state mv '$n' '$iam_binding'"
done
```

After IAM bindings are moved, **terraform apply should be without any changes**.

### Added `random_password` field in `additional_users` variable in postgresql module
This change is in effort to align the behavior of `additional_users` variable in all the modules. Setting `random_password` field generates a random password for the user. Exactly one of `password` or `random_password` should be set.

```diff
module "pg" {
  source  = "GoogleCloudPlatform/sql-db/google//modules/postgresql"
- version = "~> 13.0"
+ version = "~> 14.0"

  name                 = "test"
  database_version     = "POSTGRES_14"
  project_id           = var.project_id
  zone                 = "europe-west1-b"
  region               = "europe-west1"
  tier                 = "db-custom-1-3840"

  additional_users = [
    {
      name            = "john"
      password        = "password"
+     random_password = false
    }
  ]
}
```

### Added `random_password` field in `additional_users` variable in mssql module
This change is in effort to align the behavior of `additional_users` variable in all the modules. Setting `random_password` field generates a random password for the user. At most one of `password` or `random_password` should be set.

```diff
module "mssql" {
  source  = "GoogleCloudPlatform/sql-db/google//modules/mssql"
- version = "~> 13.0"
+ version = "~> 14.0"

  name                 = "test"
  database_version     = "SQLSERVER_2017_STANDARD"
  project_id           = var.project_id
  zone                 = "europe-west1-b"
  region               = "europe-west1"
  tier                 = "db-custom-1-3840"

  additional_users = [
    {
      name            = "john"
      password        = "password"
+     random_password = false
    }
  ]
}
```

### Changed the variable type of `additional_users` in mysql module
This change is in effort to align the behavior of `additional_users` variable in all the modules. Setting `random_password` field generates a random password for the user. At most one of `password` or `random_password` should be set. `user_host` would be the host value for the additional users if the `host` field is set as `null`. You can use `type` to create IAM users.

```diff
module "mysql" {
  source  = "GoogleCloudPlatform/sql-db/google//modules/mysql"
- version = "~> 13.0"
+ version = "~> 14.0"

  name                 = "test"
  database_version     = "MYSQL_8_0"
  project_id           = var.project_id
  zone                 = "europe-west1-b"
  region               = "europe-west1"
  tier                 = "db-custom-1-3840"

  additional_users = [
    {
      name            = "john"
      password        = "password"
+     random_password = false
+     host            = null
+     type            = null
    }
  ]
}
```

### Added `random_password` field in `additional_users` variable in safer_mysql module
This change is in effort to align the behavior of `additional_users` variable in all the modules. Setting `random_password` field generates a random password for the user. At most one of `password` or `random_password` should be set.

```diff
module "smysql" {
  source  = "GoogleCloudPlatform/sql-db/google//modules/safer_mysql"
- version = "~> 13.0"
+ version = "~> 14.0"

  name                 = "test"
  database_version     = "MYSQL_8_0"
  project_id           = var.project_id
  zone                 = "europe-west1-b"
  region               = "europe-west1"
  tier                 = "db-custom-1-3840"

  additional_users = [
    {
      name            = "john"
      password        = "password"
      type            = "BUILT_IN"
      host            = "%"
+     random_password = false
    }
  ]
}
```

### [Terraform](https://www.terraform.io/downloads.html) >= 1.3.0 is required as `name_override` is made optional in the `read_replica` object
The [`name_override`](https://github.com/terraform-google-modules/terraform-google-sql-db/blob/master/modules/postgresql/variables.tf#L232) attribute for [`read_replica`](https://github.com/terraform-google-modules/terraform-google-sql-db/blob/master/modules/postgresql/variables.tf#L228) is optional now. If passed, the name for the read replica will be set as such. Since [optional attributes](https://developer.hashicorp.com/terraform/language/expressions/type-constraints#optional-object-type-attributes)
is a version 1.3 feature, the configuration will fail if the pinned version is < 1.3.

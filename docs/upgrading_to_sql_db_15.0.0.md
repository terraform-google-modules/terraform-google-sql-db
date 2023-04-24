# Upgrading to SQL DB 15.0.0

The 15.0.0 release of SQL DB is a backward incompatible release.
This incompatibility affects `postgresql` submodule that uses IAM authentication.

## Migration Instructions

### `iam_user_emails` moved to `iam_users` and changed to be an list(object)

Prior to the `15.0.0` release, the `postgresql` submodule took a `list(string)` for `iam_user_emails`.

This meant that it was not possible to create a `google_service_account` and corresponding `google_sql_user`
in a single `terraform apply` because the `email` is `(known after apply)` and was used in the resource address.
See [issue 413](https://github.com/terraform-google-modules/terraform-google-sql-db/issues/413) for more details.

In the `15.0.0` release, the input/output variable has been renamed from `iam_user_emails` to `iam_users`, and
now accepts a `list(object({id=string, email=string}))`, where `id` is used in the resource address.

This allows a value that is known at `plan` time to be passed, for example `google_service_account.my_service_account.account_id`
would be a good candidate for this.

```diff
module "pg" {
  source  = "GoogleCloudPlatform/sql-db/google//modules/postgresql"
  - version = "~> 14.0"
  + version = "~> 15.0"

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

- iam_user_emails = [
-   "test-sa@${var.project_id}.iam.gserviceaccount.com",
-   "john.doe@gmail.com"
- ]
+ iam_users = [
+   {
+      id = "test-sa",
+      email = "test-sa@${var.project_id}.iam.gserviceaccount.com",
+   },
+   {
+      id = "john.doe",
+      email = "john.doe@gmail.com",
+   },
+ ]
}

+ moved {
+   from = module.pg.google_sql_user.iam_account["test-sa@${var.project_id}.iam.gserviceaccount.com true"]
+   to   = module.pg.google_sql_user.iam_account["test-sa"]
+ }

+ moved {
+   from = module.pg.google_sql_user.iam_account["john.doe@gmail.com false"]
+   to   = module.pg.google_sql_user.iam_account["john.doe"]
+ }

```

We recommend using `moved` blocks as [documented here](https://developer.hashicorp.com/terraform/language/modules/develop/refactoring)
to explicitly migrate your state. You can find the list of state addresses to move using:

```shell
terraform state list | grep google_sql_user.iam_account
```

If you do not wish to use `moved` blocks, you can instead migrate your state using `terraform state mv`:
```shell
terraform state mv \
  'module.pg.google_sql_user.iam_account["test-sa@$my-project-id.iam.gserviceaccount.com true"]' \
  'module.pg.google_sql_user.iam_account["test-sa"]'
```

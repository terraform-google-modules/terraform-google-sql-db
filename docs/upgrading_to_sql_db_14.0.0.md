# Upgrading to SQL DB 14.0.0

The 14.0.0 release of SQL DB is a backward incompatible release. This incompatibility affects `postgresql` submodule that uses IAM authentication.

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

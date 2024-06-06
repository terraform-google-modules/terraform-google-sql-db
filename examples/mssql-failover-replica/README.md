# CloudSql MS SQL Server database Example with failover replication

This example shows how create private MS SQL Server database with cross region failover replica using the Terraform module. You can promote failover replica without losing state file sync.

- Set `enable_default_db` and `enable_default_user` to `null`
- Dont set `additional_databases`, `user_name`, `user_password` and `additional_users`
- `availability_type` in all replica should be set to `ZONAL`

## Run Terraform

```
terraform init
terraform plan
terraform apply
```

## Failover to Instance 2

Promote instance 2 as primary and change instance 1 as failover replica

1) remove  `master_instance_name` from instance 2 and Execute `terraform apply`

```diff
module "mssql2" {
  source  = "terraform-google-modules/sql-db/google//modules/mssql"
  version = "~> 20.2"

-  master_instance_name = module.mssql1.instance_name

...
}
```

2) Remove instance 1 by removing instance 1 code and Execute `terraform apply`

```diff
- module "mssql1" {
-   source  = "terraform-google-modules/sql-db/google//modules/mssql"
-   version = "~> 20.0"
-   region = local.region_1
-   name                 = "tf-mssql-public-1"
-   random_instance_name = true
-   project_id           = var.project_id
- ...
- }
- output "instance_name1" {
-   description = "The name for Cloud SQL instance"
-   value       = module.mssql1.instance_name
- }
- output "mssql_connection" {
-   value       = module.mssql1.instance_connection_name
-   description = "The connection name of the master instance to be used in connection strings"
- }
- output "public_ip_address" {
-   value       = module.mssql1.instance_first_ip_address
-   description = "Public ip address"
- }
```

3) Create instance 1 as failover replica by adding instance 1 code with following additional line and Execute `terraform apply`

```diff
module "mssql1" {
  source  = "terraform-google-modules/sql-db/google//modules/mssql"
  version = "~> 20.0"

+ master_instance_name = module.mssql2.instance_name

...

}
```


## Cleanup

To remove all resources created by terraform:

```bash
terraform destroy
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| network\_name | The ID of the network in which to provision resources. | `string` | `"test-mssql-failover"` | no |
| project\_id | The project to run tests against | `string` | n/a | yes |
| sql\_server\_audit\_config | SQL server audit config settings. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| instance\_name1 | The name for Cloud SQL instance |
| instance\_name2 | The name for Cloud SQL instance 2 |
| master\_instance\_name2 | n/a |
| mssql\_connection | The connection name of the master instance to be used in connection strings |
| project\_id | n/a |
| public\_ip\_address | Public ip address |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->


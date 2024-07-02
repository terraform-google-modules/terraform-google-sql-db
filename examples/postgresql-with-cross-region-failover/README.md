# Cloud Postgresql Database Example with failover replication

This example shows how to create a private HA Postgres Cloud SQL cluster with cross region failover replica using the Terraform module. You can promote failover replica without losing state file sync.

- Set `enable_default_db` and `enable_default_user` to `null`
- Dont set `additional_databases`, `user_name`, `user_password` and `additional_users`
- `availability_type` in all replica should be set to `ZONAL`


## Run Terraform

Create resources with terraform:

```bash
terraform init
terraform plan
terraform apply
```

## Failover to Instance 2

Promote instance 2 as primary and change instance 1 as failover replica

1) remove  `master_instance_name` from instance 2 and Execute `terraform apply`

```diff
module "pg2" {
  source  = "terraform-google-modules/sql-db/google//modules/postgresql"
  version = "~> 20.2"

-  master_instance_name = module.pg1.instance_name

...
}
```

2) Remove instance 1 by removing all entries of instance 1 and Execute `terraform apply`

```diff
- module "pg1" {
-   source  = "terraform-google-modules/sql-db/google//modules/postgresql"
-   version = "~> 20.0"
-   name                 = var.pg_name_1
-   random_instance_name = true
-   project_id           = var.project_id
-   database_version     = "POSTGRES_14"
-   region               = local.region_1
-   edition            = local.edition
-   data_cache_enabled = local.data_cache_enabled
- ...
- }
- output "instance1_name" {
-   description = "The name for Cloud SQL instance"
-   value       = module.pg1.instance_name
- }
- output "instance1_replicas" {
-   value     = module.pg1.replicas
-   sensitive = true
- }
- output "instance1_instances" {
-   value     = module.pg1.instances
-   sensitive = true
- }
- output "kms_key_name1" {
-   value     = module.pg1.primary.encryption_key_name
-   sensitive = true
- }
```

3) Create instance 1 as failover replica by adding instance 1 code with following additional line and Execute `terraform apply`

```diff
module "pg1" {
  source  = "terraform-google-modules/sql-db/google//modules/postgresql"
  version = "~> 20.0"

+ master_instance_name = module.pg2.instance_name

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
| network\_name | The ID of the network in which to provision resources. | `string` | `"test-postgres-failover"` | no |
| pg\_ha\_external\_ip\_range | The ip range to allow connecting from/to Cloud SQL | `string` | `"192.10.10.10/32"` | no |
| pg\_name\_1 | The name for Cloud SQL instance | `string` | `"tf-pg-x-1"` | no |
| pg\_name\_2 | The name for Cloud SQL instance | `string` | `"tf-pg-x-2"` | no |
| project\_id | The project to run tests against | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| instance1\_instances | n/a |
| instance1\_name | The name for Cloud SQL instance |
| instance1\_replicas | n/a |
| instance2\_instances | n/a |
| instance2\_name | The name for Cloud SQL instance |
| instance2\_replicas | n/a |
| kms\_key\_name1 | n/a |
| kms\_key\_name2 | n/a |
| master\_instance\_name | n/a |
| project\_id | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

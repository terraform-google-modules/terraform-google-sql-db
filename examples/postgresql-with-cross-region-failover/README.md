# Cloud SQL Database Example with failover replication

This example shows how to create a public HA Postgres Cloud SQL cluster with cross region failover replica using the Terraform module. You can promote failover replica without losing state file sync

## Run Terraform

Create resources with terraform:

```bash
terraform init
terraform plan
terraform apply
```

## Failover to Instance 2
 
Promote instance 2 as primary and change instance 1 as failover replica

1) remove  `primary_instance_name` from instance 2

```diff
module "pg2" {
  source  = "terraform-google-modules/sql-db/google//modules/postgresql"
  version = "~> 20.0"

-  primary_instance_name = module.pg1.instance_name

...
}
```

2) Execute `terraform apply`

```terraform
terraform apply
```

3) Remove instance 1 by renaming [pg1.tf](./pg1.tf) to pg1.tf.bak

4) In order to create old instance 1 as failover replica rename pg1.tf.bak to pg1.tf and add following line

```diff
module "pg1" {
  source  = "terraform-google-modules/sql-db/google//modules/postgresql"
  version = "~> 20.0"

+ primary_instance_name = module.pg2.instance_name

...

}
```

2) Execute `terraform apply`

```terraform
terraform apply
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

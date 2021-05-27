# Cloud MS SQL Server database Example

This example shows how create MS SQL Server database using the Terraform module.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The name for Cloud SQL instance | `string` | `"tf-mssql-public"` | no |
| project\_id | The project to run tests against | `string` | n/a | yes |
| region | n/a | `string` | `"us-central1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| instance\_name | The name for Cloud SQL instance |
| mssql\_connection | The connection name of the master instance to be used in connection strings |
| project\_id | n/a |
| public\_ip\_address | Public ip address |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Run Terraform

```
terraform init
terraform plan
terraform apply
```

## Test connection to database

```bash
gcloud sql connect $(terraform output instance_name) --user=simpleuser
```
## Cleanup

Remove all resources created by terraform:

```bash
terraform destroy
```

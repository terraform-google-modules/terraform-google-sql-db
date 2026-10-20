# Cloud MS SQL Server Private Service Connect Example

This example shows how to create a MS SQL Server instance reachable only through Private Service Connect, using the Terraform module.

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The name for Cloud SQL instance | `string` | `"tf-mssql-psc"` | no |
| project\_id | The project to run tests against | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| instance\_name | The name for Cloud SQL instance |
| instance\_psc\_attachment | The psc\_service\_attachment\_link created for the master instance |
| mssql\_connection | The connection name of the master instance to be used in connection strings |
| project\_id | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

## Run Terraform

```
terraform init
terraform plan
terraform apply
```

## Connect to the database

The instance has no public or private services access IP. Create a Private Service Connect endpoint in a consumer VPC of an allowed project, targeting the service attachment in the `instance_psc_attachment` output, then connect to the endpoint address with user `simpleuser`.

## Cleanup

Remove all resources created by terraform:

```bash
terraform destroy
```

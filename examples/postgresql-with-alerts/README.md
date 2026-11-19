# Cloud SQL Database Example

This example shows how to create the Postgres Cloud SQL database with default alerts enabled using the Terraform module.

The example sets `disk_autoresize_limit`, so the disk alert is enabled and fires when disk usage reaches 80% of the limit. With unlimited automatic storage increase (the module default), the disk alert is disabled.

## Run Terraform

Create resources with terraform:

```bash
terraform init
terraform plan
terraform apply
```

To remove all resources created by terraform:

```bash
terraform destroy
```

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| db\_name | The name of the SQL Database instance | `string` | `"example-postgres-with-alerts"` | no |
| project\_id | The ID of the project in which resources will be provisioned. | `string` | n/a | yes |
| test\_email | Test email address for the notification channel | `string` | `"test@example.com"` | no |

## Outputs

| Name | Description |
|------|-------------|
| alert\_policies | Alert policies created for the instance |
| name | The name for Cloud SQL instance |
| project\_id | The project to run tests against |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

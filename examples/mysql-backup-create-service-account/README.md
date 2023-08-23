# Cloud SQL Database Backup Example

This example shows how to create:

- a MySQL CloudSQL Instance
- A GCS Bucket for storing the Backup
- The Workflows for exports (external backups) and (internal) backups

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
| project\_id | The ID of the project in which resources will be provisioned. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| backup\_workflow\_name | The name for internal backup workflow |
| export\_workflow\_name | The name for export workflow |
| instance\_name | The name of the SQL instance |
| mysql-password | n/a |
| project\_id | The project ID used |
| service\_account | The service account email running the scheduler and workflow |
| workflow\_location | The location where the workflows run |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

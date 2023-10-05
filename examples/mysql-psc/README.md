# Cloud SQL Database Example

This example shows how to create the public MySQL HA Cloud cluster using the Terraform module.

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
| mysql\_ha\_name | The name for Cloud SQL instance | `string` | `"tf-mysql-psc"` | no |
| project\_id | The project to run tests against | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| name | The name for Cloud SQL instance |
| project\_id | n/a |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

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

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_authorized_networks"></a> [authorized\_networks](#input\_authorized\_networks) | List of mapped public networks authorized to access to the instances. Default - short range of GCP health-checkers IPs | `list(map(string))` | <pre>[<br>  {<br>    "name": "sample-gcp-health-checkers-range",<br>    "value": "130.211.0.0/28"<br>  }<br>]</pre> | no |
| <a name="input_db_name"></a> [db\_name](#input\_db\_name) | The name of the SQL Database instance | `string` | `"example-mysql-public"` | no |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The ID of the project in which resources will be provisioned. | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region of the Cloud SQL resources | `string` | `"us-central1"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backup_workflow_name"></a> [backup\_workflow\_name](#output\_backup\_workflow\_name) | The name for internal backup workflow |
| <a name="output_export_workflow_name"></a> [export\_workflow\_name](#output\_export\_workflow\_name) | The name for export workflow |
| <a name="output_instance_name"></a> [instance\_name](#output\_instance\_name) | The name of the SQL instance |
| <a name="output_project_id"></a> [project\_id](#output\_project\_id) | The project ID used |
| <a name="output_service_account"></a> [service\_account](#output\_service\_account) | The service account email running the scheduler and workflow |
| <a name="output_workflow_location"></a> [workflow\_location](#output\_workflow\_location) | The location where the workflows run |

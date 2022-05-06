# GCP CloudSQL Backup

## Internal Backups

Cloud SQL provides an [internal default backup options](https://cloud.google.com/sql/docs/mysql/backup-recovery/backups#automated-backups).
This supports standard use-cases. (One Backup ~ every 24h stored for up to 365 days).

For many use cases this might be enough but for many other not:
e.g. for SQL Server there is currently no Point-in-time Recovery (PITR) available so you might want to take more updates.
Or your instance is not that critical and to [save costs](https://cloud.google.com/sql/docs/mysql/backup-recovery/backups#what_backups_cost) you are fine with one backup every 7 days.

> **Note**: To enable or disable the internal backups use the Terraform variable `enable_internal_backup`

For internal backups the workflow also takes care about deleting the old backups.

## Exports to GCS

But the backups mentioned above are bound to the SQL instance.
This means as soon as you [delete the instance](https://cloud.google.com/sql/docs/mysql/delete-instance) you are also loosing your backups.
To avoid this you can also export data. There is a second workflow doing exactly that.

> **Note**: To enable or disable the exports to GCS Buckets use the Terraform variable `enable_export_backup`

### Deleting old exports

The export workflow does not take care about deleting old backups. Please take care about that yourself.
You can use [Object Lifecycle Management](https://cloud.google.com/storage/docs/lifecycle) to delete old exports.

## Required APIs

- `workflows.googleapis.com`
- `cloudscheduler.googleapis.com`

## Monitoring

Monitoring your exports/backups is not part of this module.
Please ensure that you monitor for failed workflows to ensure you have regular backups/exports.

A good metric could be to monitor for workflow executions that not succeeded:

```mql
fetch workflows.googleapis.com/Workflow
| metric 'workflows.googleapis.com/finished_execution_count'
| filter (metric.status != 'SUCCEEDED')
| group_by 1d,
    [value_finished_execution_count_mean: mean(value.finished_execution_count)]
| every 1d
| condition val() > 0 '1'
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup_retention_time"></a> [backup\_retention\_time](#input\_backup\_retention\_time) | The number of days backups should be kept | `number` | `30` | no |
| <a name="input_backup_schedule"></a> [backup\_schedule](#input\_backup\_schedule) | The cron schedule to execute the internal backup | `string` | `"45 2 * * *"` | no |
| <a name="input_enable_export_backup"></a> [enable\_export\_backup](#input\_enable\_export\_backup) | Weather to create exports to GCS Buckets with this module | `bool` | `true` | no |
| <a name="input_enable_internal_backup"></a> [enable\_internal\_backup](#input\_enable\_internal\_backup) | Wether to create internal backups with this module | `bool` | `true` | no |
| <a name="input_export_databases"></a> [export\_databases](#input\_export\_databases) | The list of databases that should be exported - if is an empty set all databases will be exported | `set(string)` | `[]` | no |
| <a name="input_export_schedule"></a> [export\_schedule](#input\_export\_schedule) | The cron schedule to execute the export to GCS | `string` | `"15 3 * * *"` | no |
| <a name="input_export_uri"></a> [export\_uri](#input\_export\_uri) | The bucket and path uri for exporting to GCS | `string` | n/a | yes |
| <a name="input_project_id"></a> [project\_id](#input\_project\_id) | The project ID | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region where to run the workflow | `string` | n/a | yes |
| <a name="input_scheduler_timezone"></a> [scheduler\_timezone](#input\_scheduler\_timezone) | The Timezone in which the Scheduler Jobs are triggered | `string` | `"Etc/GMT"` | no |
| <a name="input_service_account"></a> [service\_account](#input\_service\_account) | The service account to use for running the workflow and triggering the workflow by Cloud Scheduler - If empty or null a service account will be created. If you have provided a service account you need to grant the Cloud SQL Admin and the Workflows Invoker role to that | `string` | `null` | no |
| <a name="input_sql_instance"></a> [sql\_instance](#input\_sql\_instance) | The name of the SQL instance to backup | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_backup_workflow_name"></a> [backup\_workflow\_name](#output\_backup\_workflow\_name) | The name for internal backup workflow |
| <a name="output_export_workflow_name"></a> [export\_workflow\_name](#output\_export\_workflow\_name) | The name for export workflow |
| <a name="output_service_account"></a> [service\_account](#output\_service\_account) | The service account email running the scheduler and workflow |

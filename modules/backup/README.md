# GCP CloudSQL Backup

## Internal Backups

Cloud SQL is providing an [internal default backup options](https://cloud.google.com/sql/docs/mysql/backup-recovery/backups#automated-backups).
This supports standard use-cases. (One Backup ~ every 24h stored for up to 365 days).

For many use cases this might be enough but for many other not:
e.g. for SQL Server there is currently no Point-in-time Recovery (PITR) available so you might want to take more updates.
Or your instance is not that critical and to [save costs](https://cloud.google.com/sql/docs/mysql/backup-recovery/backups#what_backups_cost) you are fine with one backup every 7 days.

> **Note**: To enable or disable the internal backups use the Terraform variable `backup`

For internal backups the workflow also takes care about deleting the old backups.

## Exports to GCS

But the backups mentioned above are bound to the SQL instance.
This means as soon as you [delete the instance](https://cloud.google.com/sql/docs/mysql/delete-instance) you are also loosing your backups.
To avoid this you can also export data. There is a second workflow doing exactly that.

> **Note**: To enable or disable the exports to GCS Buckets use the Terraform variable `export`

### Deleting old exports

The export workflow does not take care about deleting old backups. Please take care about that yourself.
You can use [Object Lifecycle Management](https://cloud.google.com/storage/docs/lifecycle) to delete old exports.

## Required APIs

- `workflows.googleapis.com`
- `cloudscheduler.googleapis.com`

## Monitoring

Monitoring your exports/backups is not part of this module.
Please ensure that you monitor for failed workflows to ensure you have regular backups/exports.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_backup"></a> [backup](#input\_backup) | Weather to create internal backups with this module | `bool` | `true` | no |
| <a name="input_backup-retention-time"></a> [backup-retention-time](#input\_backup-retention-time) | The number of Days Backups should be kept | `number` | `30` | no |
| <a name="input_backup-schedule"></a> [backup-schedule](#input\_backup-schedule) | The cron schedule to execute the internal backup | `string` | `"45 2 * * *"` | no |
| <a name="input_export"></a> [export](#input\_export) | Weather to create exports to GCS Buckets with this module | `bool` | `true` | no |
| <a name="input_export-databases"></a> [export-databases](#input\_export-databases) | The list of databases that should be exported - if is an empty set all databases will be exported | `set(string)` | `[]` | no |
| <a name="input_export-schedule"></a> [export-schedule](#input\_export-schedule) | The cron schedule to execute the export to GCS | `string` | `"15 3 * * *"` | no |
| <a name="input_export-uri"></a> [export-uri](#input\_export-uri) | The bucket and path uri for exporting to GCS | `string` | n/a | yes |
| <a name="input_project-id"></a> [project-id](#input\_project-id) | The project ID | `string` | n/a | yes |
| <a name="input_region"></a> [region](#input\_region) | The region where to run the workflow | `string` | n/a | yes |
| <a name="input_scheduler-timezone"></a> [scheduler-timezone](#input\_scheduler-timezone) | The Timezone in which the Scheduler Jobs are triggered | `string` | `"Etc/GMT"` | no |
| <a name="input_service-account"></a> [service-account](#input\_service-account) | The service account to use for running the workflow - If empty or null a service account will be created. If you have provided a service account you need to grant the Cloud SQL Admin and the Workflows Invoker role to that | `string` | `null` | no |
| <a name="input_sql-instance"></a> [sql-instance](#input\_sql-instance) | The name of the SQL instance to backup | `string` | n/a | yes |

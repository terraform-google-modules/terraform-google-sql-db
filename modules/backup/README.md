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

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| backup\_retention\_time | The number of days backups should be kept | `number` | `30` | no |
| backup\_schedule | The cron schedule to execute the internal backup | `string` | `"45 2 * * *"` | no |
| compress\_export | Whether or not to compress the export when storing in the bucket; Only valid for MySQL and PostgreSQL | `bool` | `true` | no |
| enable\_export\_backup | Weather to create exports to GCS Buckets with this module | `bool` | `true` | no |
| enable\_internal\_backup | Wether to create internal backups with this module | `bool` | `true` | no |
| export\_databases | The list of databases that should be exported - if is an empty set all databases will be exported | `set(string)` | `[]` | no |
| export\_schedule | The cron schedule to execute the export to GCS | `string` | `"15 3 * * *"` | no |
| export\_uri | The bucket and path uri for exporting to GCS | `string` | n/a | yes |
| project\_id | The project ID | `string` | n/a | yes |
| region | The region where to run the workflow | `string` | `"us-central1"` | no |
| scheduler\_timezone | The Timezone in which the Scheduler Jobs are triggered | `string` | `"Etc/GMT"` | no |
| service\_account | The service account to use for running the workflow and triggering the workflow by Cloud Scheduler - If empty or null a service account will be created. If you have provided a service account you need to grant the Cloud SQL Admin and the Workflows Invoker role to that | `string` | `null` | no |
| sql\_instance | The name of the SQL instance to backup | `string` | n/a | yes |
| unique\_suffix | Unique suffix to add to scheduler jobs and workflows names. | `string` | `""` | no |

## Outputs

| Name | Description |
|------|-------------|
| backup\_workflow\_name | The name for internal backup workflow |
| export\_workflow\_name | The name for export workflow |
| region | The region for running the scheduler and workflow |
| service\_account | The service account email running the scheduler and workflow |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

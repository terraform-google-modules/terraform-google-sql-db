# GCP CloudSQL Restore

## Import from GCS Export Dump

This module can be used for [importing Cloud SQL Postgres database](https://cloud.google.com/sql/docs/postgres/import-export/import-export-sql) from a SQL export dump stored in GCS bucket.

This module uses the SQL export dump file timestamp passed as an input parameter to the Workflow to get the exported dumps from GCS. Following are the steps in import workflow:

1. Fetch list of databases from the source database instance (one that the export was created for)
2. Delete the databases (list from step 1) except system (`postgres` for Postgres and `tempdb` for SQL Server) databases in the database instance that we are going to import databases to
3. Create the databases (list from step 1) except system databases in the import database instance
4. Fetch the SQL export file(s) from GCS and import those into the import database instance
5. The import API call is asynchronous, so the workflow checks the status of the import at regular interval and wait until it finishes

## How to run

```
gcloud workflows run [WORKFLOW_NAME] --data='{"exportTimestamp":"[EXPORT_TIMESTAMP]"}'
```

where `WORKFLOW_NAME` is the name of your import workflow and `exportTimestamp` is the timestamp of your export file(s) (you can get it from GCS object key of the export file). For example:

```
gcloud workflows run my-import-workflow --data='{"exportTimestamp": "1658779617"}'
```

## Required APIs

- `workflows.googleapis.com`
- `cloudscheduler.googleapis.com`

<!-- BEGINNING OF PRE-COMMIT-TERRAFORM DOCS HOOK -->
## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| import\_databases | The list of databases that should be imported - if is an empty set all databases will be imported | `set(string)` | `[]` | no |
| import\_uri | The bucket and path uri of GCS backup file for importing | `string` | n/a | yes |
| project\_id | The project ID | `string` | n/a | yes |
| region | The region to run the workflow | `string` | `"us-central1"` | no |
| service\_account | The service account to use for running the workflow and triggering the workflow by Cloud Scheduler - If empty or null a service account will be created. If you have provided a service account you need to grant the Cloud SQL Admin and the Workflows Invoker role to that | `string` | `null` | no |
| sql\_instance | The name of the SQL instance to backup | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| import\_workflow\_name | The name for import workflow |
| region | The region for running the scheduler and workflow |
| service\_account | The service account email running the scheduler and workflow |

<!-- END OF PRE-COMMIT-TERRAFORM DOCS HOOK -->

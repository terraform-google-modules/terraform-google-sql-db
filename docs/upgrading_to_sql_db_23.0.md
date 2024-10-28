# Upgrading to SQL DB 23.0

The 23.0 release of SQL DB is a backward incompatible release.

# Cloud SQL Service Account role update in backup module

Changed `storage.objectCreator` role to `storage.objectAdmin` for Cloud SQL Service Account on the bucket used for exporting the database, due to GCP internal changes in the export process.

# Minimum provider version
Minimum provider version for `mysql`, `safer_mysql` and `postgresql sub-module` is `6.1`


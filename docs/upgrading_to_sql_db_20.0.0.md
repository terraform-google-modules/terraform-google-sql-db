# Upgrading to SQL DB 20.0.0

The 20.0.0 release of SQL DB is a backward incompatible release.

This update requires upgrading the minimum provider version `5.12`.

In `mysql` and `postgresql` sub-module output `instance_server_ca_cert` and `replicas_instance_server_ca_certs` are also marked as `sensitive`

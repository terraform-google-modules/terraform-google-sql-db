# Upgrading to v24.0

The v24.0 release contains backwards-incompatible changes.

## Replace uses of apphub_service_uri

This release removes apphub_service_uri output. You can replace use of `apphub_service_uri` by forming the desired output as below,

```
{
    service_uri = "//cloudsql.googleapis.com/projects${element(split("/projects", module.mysql.instance_self_link), 1)}"
    service_id  = substr(format("%s-%s", <instance-name>, md5(module.mysql.instance_self_link)), 0, 63)
  }
```

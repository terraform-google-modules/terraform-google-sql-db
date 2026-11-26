# Upgrading to v29.0

The v29.0 release contains backwards-incompatible changes.

This update requires upgrading the minimum provider version from `7.22` to `7.40` in the `mysql` and `safer_mysql` modules.

`safer_mysql` now also declares `google-beta` (`>= 7.40, < 9`) in `required_providers`, because the wrapped `mysql` module creates the instance with it.

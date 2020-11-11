# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this
project adheres to [Semantic Versioning](http://semver.org/).

## [4.3.0](https://www.github.com/terraform-google-modules/terraform-google-sql-db/compare/v4.2.0...v4.3.0) (2020-11-11)


### Features

* Add variable for managing read replica deletion protection ([#155](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/155)) ([9e22cfd](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/9e22cfd35f97608d6b5a76dd30c80299d5b782e3))
* Update all uses of zone to use the expected variable format. ([#156](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/156)) ([5210126](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/52101264c2aa53bc15372b72459c5475a8aaf795))

## [4.2.0](https://www.github.com/terraform-google-modules/terraform-google-sql-db/compare/v4.1.0...v4.2.0) (2020-10-23)


### Features

* **postgres:** Added point_in_time_recovery_enabled backup option for Postgres ([#142](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/142)) ([1fcae8a](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/1fcae8a4480e1720c83eb2cb9e84c4f768dc767f))
* Add deletion_protection variable, defaulted to true ([#151](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/151)) ([69e1911](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/69e19111f8cd0fa60edea437d48e8d8a2ead1f94))

## [4.1.0](https://www.github.com/terraform-google-modules/terraform-google-sql-db/compare/v4.0.0...v4.1.0) (2020-10-06)


### Features

* Add support for backup_configuration to mssql database submodule ([#143](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/143)) ([bed1cb4](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/bed1cb487de3858c9eccfae9ebd3707f94569e0c))

## [4.0.0](https://www.github.com/terraform-google-modules/terraform-google-sql-db/compare/v3.2.0...v4.0.0) (2020-08-26)


### ⚠ BREAKING CHANGES

* Replica configuration has been reworked. Please see the upgrade guide for details.
* Users and databases have been moved and require a state migration. See the upgrade guide for details.

### Features

* Add encryption_key_name variable for MS SQL module ([#132](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/132)) ([2bd0f41](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/2bd0f41ba4ecd321f32f17dda36f7fa04dad1a41))
* Add location support to backup_configuration block ([#126](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/126)) ([aa907bd](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/aa907bd75281991445962fab2d70d04e21492a19))
* add SQL Server support with new submodule ([#112](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/112)) ([4a775fb](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/4a775fbfbc628df9573cdbc7443a2a47ed3a16e3))
* Added random_id option for instance name ([#116](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/116)) ([7c8c799](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/7c8c799552f0567d71df287770936d53b2bd8138))
* Rework replicas to use `for_each` and new configuration style ([5e1ae20](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/5e1ae20e5b7efdbb35f733897f5a4378389337d3))


### Bug Fixes

* Fix issue with replica state key and random IDs ([#141](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/141)) ([71b51fd](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/71b51fd0d4687f7c2cecf85724649a2d9785e053))
* Update versions to allow for Terraform 0.13 ([#135](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/135)) ([86c533a](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/86c533a65a2cb3d3602bb5ef1f1e1b81b4b8fa15))
* **docs:** Update links for database flags on postgresql and mysql ([#134](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/134)) ([e6a31ca](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/e6a31cad5cbb15fa3716edeebe5b1e3421e09d60))
* Relax Provider version ([#133](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/133)) ([ec2a109](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/ec2a1092a71c41abd68d974bcd03afc0ede07fd0))
* Updated users and databases creation to use for_each ([#100](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/100)) ([d433995](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/d4339956caa9d16ea07b3d99925b926765322894))

## [3.2.0](https://www.github.com/terraform-google-modules/terraform-google-sql-db/compare/v3.1.0...v3.2.0) (2020-04-24)


### Features

* Added "encryption_key_name" variable for postgresql and mysql modules. ([#101](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/101)) ([cf87a9d](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/cf87a9d1490d5970f3557866b1ad2508115904c5))
* Support new regional HA for MySQL ([#99](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/99)) ([d3ed591](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/d3ed591f4d3ef425f0afca908b0b692626e4f0da))


### Bug Fixes

* Disable binary_logging option as it is not valid for Postgres instances ([#94](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/94)) ([c74b15d](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/c74b15d09298e0821b2e5da3996fc0839c13ffeb))

## [3.1.0](https://www.github.com/terraform-google-modules/terraform-google-sql-db/compare/v3.0.0...v3.1.0) (2020-02-11)


### Features

* Update google and google-beta provider versions to ~>3.5 ([#87](https://www.github.com/terraform-google-modules/terraform-google-sql-db/issues/87)) ([706b173](https://www.github.com/terraform-google-modules/terraform-google-sql-db/commit/706b173e9a4f586e50f306fa055aad4e337e7b69))

## [3.0.0] - 2019-12-17

### Removed

- Removed variable `peering_completed`. [#78]

### Added

- The `public_ip_address`, `private_ip_address`, and `instance_address` outputs to the `mysql` submodule, the `postgresql`
submodule, and the `safer_mysql` submodule. [#76]
- Added variable `module_depends_on`. [#78]

### Changed

- Renamed output `instance_address` to `instance_ip_address` in `mysql`, `postgresql` and `safer_mysql` submodules. [#83]

## [2.0.0] - 2019-09-26

2.0.0 is a backward incompatible release. Review the
[upgrade guide](docs/upgrading_to_sql_db_2.0.0.md) for more information.

### Added

- `peering_completed` marker to postgresql module [#43]
- `private_address` to postgresql module [#43]

### Changed

- Added support for Terraform 0.12 [#53]
- the root module has been deprecated [#56]

### Fixed

- The network reference in the `private_service_access` module uses the
  self link. [#61]

## [1.2.0] - 2019-07-30

## [1.1.2] - 2019-06-14

## [1.1.1] - 2019-03-15

## [1.1.0] - 2019-02-28

## [1.0.1] - 2019-02-14

## [1.0.0] - 2019-02-14

[Unreleased]: https://github.com/terraform-google-modules/terraform-google-sql-db/compare/v3.0.0...HEAD
[3.0.0]: https://github.com/terraform-google-modules/terraform-google-sql-db/compare/v2.0.0...v3.0.0
[2.0.0]: https://github.com/terraform-google-modules/terraform-google-sql-db/compare/v1.2.0...v2.0.0
[1.2.0]: https://github.com/terraform-google-modules/terraform-google-sql-db/compare/1.1.2...v1.2.0
[1.1.2]: https://github.com/terraform-google-modules/terraform-google-sql-db/compare/1.1.1...1.1.2
[1.1.1]: https://github.com/terraform-google-modules/terraform-google-sql-db/compare/1.1.0...1.1.1
[1.1.0]: https://github.com/terraform-google-modules/terraform-google-sql-db/compare/1.0.1...1.1.0
[1.0.1]: https://github.com/terraform-google-modules/terraform-google-sql-db/compare/1.0.0...1.0.1
[1.0.0]: https://github.com/terraform-google-modules/terraform-google-sql-db/releases/tag/1.0.0

[#83]: https://github.com/terraform-google-modules/terraform-google-sql-db/pull/83
[#78]: https://github.com/terraform-google-modules/terraform-google-sql-db/pull/78
[#76]: https://github.com/terraform-google-modules/terraform-google-sql-db/pull/76
[#61]: https://github.com/terraform-google-modules/terraform-google-sql-db/pull/61
[#56]: https://github.com/terraform-google-modules/terraform-google-sql-db/pull/56
[#53]: https://github.com/terraform-google-modules/terraform-google-sql-db/pull/53
[#43]: https://github.com/terraform-google-modules/terraform-google-sql-db/pull/43

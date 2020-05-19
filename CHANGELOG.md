# Change Log

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/) and this
project adheres to [Semantic Versioning](http://semver.org/).

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

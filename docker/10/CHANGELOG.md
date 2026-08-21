# Changelog - Rocky Linux 10

All notable changes to the Rocky Linux 10 Docker image will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [10.2.0](https://github.com/snowdreamtech/rocky/compare/10-v10.2.0...10-v10.2.0) (2026-08-21)


### 🐛 Bug Fixes

* **docker:** remove devel repository to prevent package version conflicts ([bb363ce](https://github.com/snowdreamtech/rocky/commit/bb363ce046d857a90f723ab1c6b7fa2d545acfb3))

## [10.2.0](https://github.com/snowdreamtech/rocky/compare/10-v10.2.0...10-v10.2.0) (2026-07-24)


### 🚀 Features

* **docker:** align all versions with alpine project standards ([eef2c0c](https://github.com/snowdreamtech/rocky/commit/eef2c0ceff2e3892cb465a5074689d69fbba7b30))
* **docker:** implement modular entrypoint system ([b6b1064](https://github.com/snowdreamtech/rocky/commit/b6b106490c3efc4fac2bf14a351db8a3bc2c561e))
* **docker:** implement standardized package management ([d220f90](https://github.com/snowdreamtech/rocky/commit/d220f90d32cb3e77e1bceb804ffb82358e49135e))
* **docker:** initialize multi-version directory structure ([c00da9d](https://github.com/snowdreamtech/rocky/commit/c00da9d96ba6e77640dd5319ba904c2c2905846a))
* **docker:** migrate and standardize Dockerfile templates ([22b7276](https://github.com/snowdreamtech/rocky/commit/22b7276d16eadf605b4a45731e3bbdf790d6994b))


### 🐛 Bug Fixes

* **docker:** add missing vimrc.local copy instruction ([915e97b](https://github.com/snowdreamtech/rocky/commit/915e97b167925aa6c6445d469a6247994bd160b3))


### ♻️ Miscellaneous Chores

* release main ([8b6a86a](https://github.com/snowdreamtech/rocky/commit/8b6a86abc42f61f46b7297223ff9258e118bcb6e))
* update Rocky Linux 10 target version to 10.2 across documentation and changelogs ([40512fc](https://github.com/snowdreamtech/rocky/commit/40512fcec27fc4fe31903687a8f10dfd564aa58c))

## [Unreleased]

### Added
- Initial Rocky Linux 10.2 Docker image implementation
- Multi-architecture support (amd64, arm64, ppc64le, s390x)
- Modular entrypoint system with alpine-style orchestration
- User mapping support with PUID/PGID configuration
- Debug logging with DEBUG environment variable
- Timezone configuration support
- Network capability configuration (CAP_NET_BIND_SERVICE)
- Passwordless sudo support
- gosu integration for secure privilege dropping
- Comprehensive package installation with CRB, devel, and extras repositories
- EPEL repository integration
- Essential development and operational tools

### Security
- GPG verification for gosu installation
- Proper privilege dropping mechanisms
- Secure user creation and mapping
- File permission management with UMASK support

### Infrastructure
- Standardized OCI annotations
- Build argument support for customization
- Environment variable configuration
- Proper cleanup and cache management

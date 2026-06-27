# Changelog - Rocky Linux 8

All notable changes to the Rocky Linux 8 Docker image will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [0.7.1](https://github.com/snowdreamtech/rocky/compare/8-v8.10.0...8-v0.7.1) (2026-06-27)


### 🚀 Features

* **docker:** align all versions with alpine project standards ([eef2c0c](https://github.com/snowdreamtech/rocky/commit/eef2c0ceff2e3892cb465a5074689d69fbba7b30))
* **docker:** implement modular entrypoint system ([b6b1064](https://github.com/snowdreamtech/rocky/commit/b6b106490c3efc4fac2bf14a351db8a3bc2c561e))
* **docker:** implement standardized package management ([d220f90](https://github.com/snowdreamtech/rocky/commit/d220f90d32cb3e77e1bceb804ffb82358e49135e))
* **docker:** initialize multi-version directory structure ([c00da9d](https://github.com/snowdreamtech/rocky/commit/c00da9d96ba6e77640dd5319ba904c2c2905846a))
* **docker:** migrate and standardize Dockerfile templates ([22b7276](https://github.com/snowdreamtech/rocky/commit/22b7276d16eadf605b4a45731e3bbdf790d6994b))


### 🐛 Bug Fixes

* **docker:** add missing vimrc.local copy instruction ([915e97b](https://github.com/snowdreamtech/rocky/commit/915e97b167925aa6c6445d469a6247994bd160b3))


### ♻️ Miscellaneous Chores

* **main:** release 0.14.0 ([043d2a4](https://github.com/snowdreamtech/rocky/commit/043d2a4202505e42c645e899c6731f5fb8f52c8e))
* release 0.6.1 ([f6fc042](https://github.com/snowdreamtech/rocky/commit/f6fc042cad7d1c4991a20657655bc4b6b339d0d9))
* release 0.7.1 ([5535492](https://github.com/snowdreamtech/rocky/commit/5535492160f3525dff06ff9f0c6d78147467bed3))
* **release:** v0.4.0 - Fix Dependabot docker-compose detection ([e91f7d8](https://github.com/snowdreamtech/rocky/commit/e91f7d882f3c7b23260f4da02f0e5e53d6399968))

## [Unreleased]

### Added
- Initial Rocky Linux 8.10 Docker image implementation
- Multi-architecture support (amd64, arm64, ppc64le, s390x)
- Modular entrypoint system with alpine-style orchestration
- User mapping support with PUID/PGID configuration
- Debug logging with DEBUG environment variable
- Timezone configuration support
- Network capability configuration (CAP_NET_BIND_SERVICE)
- Passwordless sudo support
- gosu integration for secure privilege dropping
- Comprehensive package installation with PowerTools repository
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

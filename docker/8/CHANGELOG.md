# Changelog - Rocky Linux 8

All notable changes to the Rocky Linux 8 Docker image will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [8.10.0](https://github.com/snowdreamtech/rocky/compare/8-v8.10.0...8-v8.10.0) (2026-08-21)


### 🐛 Bug Fixes

* **docker:** remove devel repository to prevent package version conflicts ([bb363ce](https://github.com/snowdreamtech/rocky/commit/bb363ce046d857a90f723ab1c6b7fa2d545acfb3))
* **docker:** replace obsolete redhat-lsb-core with lsb-release ([619252f](https://github.com/snowdreamtech/rocky/commit/619252f7dd5d019531f50f5fda4a9dfe6909017d))
* **docker:** restore redhat-lsb-core package name for Rocky 8 ([83f92b0](https://github.com/snowdreamtech/rocky/commit/83f92b03d33425571ec36f5c72cc18df0ce18e7f))

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

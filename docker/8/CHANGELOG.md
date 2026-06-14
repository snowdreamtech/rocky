# Changelog - Rocky Linux 8

All notable changes to the Rocky Linux 8 Docker image will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [8.10.1](https://github.com/snowdreamtech/rocky/compare/8-v8.10.0...8-v8.10.1) (2026-06-14)


### ♻️ Miscellaneous Chores

* **main:** release 0.14.0 ([043d2a4](https://github.com/snowdreamtech/rocky/commit/043d2a4202505e42c645e899c6731f5fb8f52c8e))

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

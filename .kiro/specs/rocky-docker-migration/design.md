# Design Document: Rocky Docker Migration

## Overview

This design document outlines the comprehensive technical approach for migrating Rocky Linux Docker images from the rocky0 project to the rocky project. The migration establishes a standardized, multi-version Docker ecosystem supporting Rocky Linux versions 8, 9, and 10 with proper architecture support, following established patterns from the alpine project while maintaining Rocky Linux-specific configurations.

### Design Goals

1. **Standardization**: Align with alpine project patterns for consistency across Linux distribution images
2. **Multi-Version Support**: Support Rocky Linux versions 8, 9, and 10 with version-specific configurations
3. **Architecture Coverage**: Provide multi-architecture support (amd64, arm64, ppc64le, s390x) based on Rocky Linux availability
4. **Maintainability**: Implement modular, extensible architecture with clear separation of concerns
5. **Security**: Follow security best practices with proper user mapping, privilege management, and package handling
6. **Automation**: Establish CI/CD workflows for automated builds, testing, and deployment

## Architecture

### System Architecture Overview

The rocky-docker-migration implements a layered architecture with clear separation between:

1. **Infrastructure Layer**: Base Rocky Linux images and system packages
2. **Configuration Layer**: Environment variables, user mapping, and runtime parameters
3. **Initialization Layer**: Modular entrypoint system with extensible scripts
4. **Application Layer**: User commands and workload execution
5. **Orchestration Layer**: CI/CD workflows and build automation

### Directory Structure Design

```
rocky/
├── docker/                          # Docker ecosystem root
│   ├── 8/                          # Rocky Linux 8.x series
│   │   ├── Dockerfile              # Version-specific Dockerfile
│   │   ├── docker-entrypoint.sh    # Entrypoint orchestrator
│   │   ├── entrypoint.d/           # Modular initialization scripts
│   │   │   ├── 00-base-init.sh     # System initialization
│   │   │   ├── 01-base-setup.sh    # User and environment setup
│   │   │   └── 99-base-end.sh      # Final execution logic
│   │   ├── .dockerignore           # Build context optimization
│   │   └── CHANGELOG.md            # Version-specific changelog
│   ├── 9/                          # Rocky Linux 9.x series
│   │   └── [same structure as 8/]
│   └── 10/                         # Rocky Linux 10.x series
│       └── [same structure as 8/]
├── .github/
│   └── workflows/
│       ├── docker-build.yml        # Multi-architecture build workflow
│       └── docker-test.yml         # Image testing and validation
└── docs/
    ├── README.md                   # Technical documentation (English)
    ├── README_zh-CN.md             # User documentation (Chinese)
    └── migration-guide.md          # Migration documentation
```

### Component Architecture

#### 1. Base Image Strategy

Each Rocky Linux version uses minimal base images for security and size optimization:

- **Rocky 8**: `rockylinux/rockylinux:8.10`
- **Rocky 9**: `rockylinux/rockylinux:9.7`
- **Rocky 10**: `rockylinux/rockylinux:10.1`

#### 2. Entrypoint System Architecture

The entrypoint system follows a modular, extensible design:

```
docker-entrypoint.sh (Orchestrator)
├── 00-base-init.sh (System initialization)
├── 01-base-setup.sh (User/environment setup)
└── 99-base-end.sh (Command execution)
```

#### 3. Configuration Management

Environment variables provide runtime configuration:

- **User Management**: PUID, PGID, USER, PASSWORDLESS_SUDO
- **System Behavior**: KEEPALIVE, DEBUG, UMASK, WORKDIR
- **Network**: CAP_NET_BIND_SERVICE
- **Localization**: LANG, TZ

## Migration Strategy

### Phase 1: Infrastructure Setup

1. **Repository Preparation**
   - Create docker/ directory structure in rocky project
   - Set up version-specific subdirectories (8/, 9/, 10/)
   - Initialize git tracking for migration history

2. **Base Configuration Migration**
   - Extract effective configurations from rocky0 project
   - Adapt configurations for multi-version structure
   - Align with alpine project patterns while preserving Rocky Linux specifics

### Phase 2: Content Migration and Standardization

1. **Dockerfile Migration**
   - Migrate rocky0 Dockerfile to version-specific locations
   - Update base images to use minimal variants
   - Standardize OCI annotations following alpine patterns
   - Implement proper layer optimization

2. **Entrypoint System Migration**
   - Migrate docker-entrypoint.sh with alpine-style orchestration
   - Restructure entrypoint.d scripts for modularity
   - Implement debug logging and error handling
   - Add proper signal handling for graceful shutdown

3. **Package Management Standardization**
   - Standardize dnf repository configuration (CRB, devel, extras, EPEL)
   - Implement consistent package installation patterns
   - Add proper cleanup and cache management
   - Include essential development and operational tools

### Phase 3: Multi-Version Implementation

1. **Version-Specific Configurations**
   - Implement Rocky 8.10 configuration with appropriate packages
   - Implement Rocky 9.7 configuration with updated packages
   - Implement Rocky 10.1 configuration with latest packages
   - Handle version-specific differences in package availability

2. **Architecture Support Implementation**
   - Research platform availability for each Rocky Linux version
   - Configure multi-architecture build support
   - Implement platform-specific optimizations
   - Test builds across all supported architectures

### Phase 4: CI/CD and Automation

1. **Build Workflow Implementation**
   - Migrate and update GitHub Actions workflows
   - Implement Docker Buildx for multi-architecture builds
   - Configure proper caching strategies
   - Add automated testing and security scanning

2. **Quality Assurance**
   - Implement image testing workflows
   - Add security scanning with appropriate tools
   - Configure automated vulnerability assessment
   - Establish quality gates for releases

## File Organization

### Dockerfile Structure

Each version-specific Dockerfile follows this standardized structure:

```dockerfile
# Rocky Linux Base Image - Version X
FROM rockylinux/rockylinux:X.Y

# Build Arguments
ARG BUILDTIME \
    VERSION \
    REVISION \
    [runtime configuration args]

# OCI Metadata
LABEL org.opencontainers.image.* \
    [comprehensive metadata following alpine patterns]

# Environment Variables
ENV [runtime configuration variables]

# Package Installation
RUN [standardized dnf configuration and package installation]

# gosu Installation
RUN [architecture-aware gosu installation]

# File Copying
COPY entrypoint.d /usr/local/bin/entrypoint.d
COPY docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh

# Permissions
RUN chmod +x /usr/local/bin/docker-entrypoint.sh \
    && chmod +x /usr/local/bin/entrypoint.d/*

# Execution
ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["/bin/bash"]
```

### Entrypoint Script Organization

#### docker-entrypoint.sh (Orchestrator)

```bash
#!/bin/sh
set -e

# Debug logging
if [ "$DEBUG" = "true" ]; then
  echo "→ [ENTRYPOINT] Executing initialization suite"
fi

# Execute all scripts in entrypoint.d/
for script in /usr/local/bin/entrypoint.d/*; do
  if [ -x "$script" ]; then
    if [ "$DEBUG" = "true" ]; then
      echo "→ Running $(basename "$script")"
    fi
    "$script" "$@"
  fi
done

# Working directory configuration
cd "${WORKDIR:-/root}"

# Keep-alive logic
if [ "${KEEPALIVE}" = "1" ]; then
  trap : TERM INT
  tail -f /dev/null &
  wait
fi

# Command execution with privilege dropping
if [ $# -gt 0 ]; then
  if [ "$(id -u)" = "0" ]; then
    exec gosu "${PUID:-0}:${PGID:-0}" "$@"
  else
    exec "$@"
  fi
fi
```

#### 00-base-init.sh (System Initialization)

```bash
#!/bin/sh
set -e

# Timezone configuration
if [ -n "${TZ}" ] && [ "$(id -u)" = "0" ]; then
  if [ -f "/usr/share/zoneinfo/${TZ}" ]; then
    ln -snf "/usr/share/zoneinfo/${TZ}" /etc/localtime
    echo "${TZ}" > /etc/timezone
  fi
fi

# Network capabilities
if [ "${CAP_NET_BIND_SERVICE}" = "1" ] && [ "$(id -u)" = "0" ]; then
  sysctl -w net.ipv4.ip_unprivileged_port_start=0 || true
fi
```

#### 01-base-setup.sh (User and Environment Setup)

```bash
#!/bin/sh
set -e

# User creation and mapping
if [ "$(id -u)" = "0" ] && [ "${USER}" != "root" ] && [ "${PUID:-0}" -ne 0 ]; then
  # Group creation/mapping
  if ! getent group "${PGID}" >/dev/null 2>&1; then
    groupadd -g "${PGID}" "${USER}"
  fi

  # User creation/mapping
  if ! getent passwd "${PUID}" >/dev/null 2>&1; then
    useradd -u "${PUID}" -g "${PGID}" -d "/home/${USER}" -m -s /bin/bash "${USER}"
  fi

  # Passwordless sudo configuration
  if [ "${PASSWORDLESS_SUDO}" = "true" ]; then
    echo "${USER} ALL=(ALL) NOPASSWD:ALL" > "/etc/sudoers.d/${USER}"
    chmod 0440 "/etc/sudoers.d/${USER}"
  fi
fi

# UMASK configuration
umask "${UMASK:-022}"
```

#### 99-base-end.sh (Final Execution Logic)

```bash
#!/bin/sh
set -e

# Working directory setup
cd "${WORKDIR:-/root}"

# Command execution preparation
if [ $# -gt 0 ]; then
  # Commands will be executed by main entrypoint
  exit 0
fi

# Keep-alive implementation handled by main entrypoint
```

## Build System

### Docker Build Configuration

#### Multi-Architecture Support

Each Rocky Linux version supports different architectures based on official availability:

- **Rocky 8.10**: linux/amd64, linux/arm64, linux/ppc64le, linux/s390x
- **Rocky 9.7**: linux/amd64, linux/arm64, linux/ppc64le, linux/s390x
- **Rocky 10.1**: linux/amd64, linux/arm64, linux/ppc64le, linux/s390x

#### Build Arguments

Standardized build arguments across all versions:

```dockerfile
ARG BUILDTIME \
    VERSION \
    REVISION \
    KEEPALIVE=0 \
    CAP_NET_BIND_SERVICE=0 \
    LANG=C.UTF-8 \
    UMASK=022 \
    DEBUG=false \
    PASSWORDLESS_SUDO=false \
    PGID=0 \
    PUID=0 \
    USER=root \
    WORKDIR=/root
```

#### Package Management Strategy

Standardized dnf configuration for all versions:

```bash
RUN set -eux \
    && dnf install -y dnf-plugins-core \
    && dnf config-manager --set-enabled crb \
    && dnf config-manager --set-enabled devel \
    && dnf config-manager --set-enabled extras \
    && dnf -y --allowerasing install epel-release \
    && dnf -y --allowerasing update \
    && dnf -y --allowerasing install \
    [essential packages] \
    && dnf -y --allowerasing autoremove \
    && dnf -y --allowerasing clean all \
    && rm -rf /var/cache/dnf /tmp/* /var/tmp/*
```

### gosu Installation

Architecture-aware gosu installation following security best practices:

```bash
ENV GOSU_VERSION=1.19
RUN set -eux; \
    rpmArch="$(rpm --query --queryformat='%{ARCH}' rpm)"; \
    case "$rpmArch" in \
        aarch64) dpkgArch='arm64' ;; \
        armv[67]*) dpkgArch='armhf' ;; \
        i[3456]86) dpkgArch='i386' ;; \
        ppc64le) dpkgArch='ppc64el' ;; \
        riscv64 | s390x | loongarch64) dpkgArch="$rpmArch" ;; \
        x86_64) dpkgArch='amd64' ;; \
        *) echo >&2 "error: unknown/unsupported architecture '$rpmArch'"; exit 1 ;; \
    esac; \
    wget -O /usr/local/bin/gosu "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch"; \
    wget -O /usr/local/bin/gosu.asc "https://github.com/tianon/gosu/releases/download/$GOSU_VERSION/gosu-$dpkgArch.asc"; \
    export GNUPGHOME="$(mktemp -d)"; \
    gpg --batch --keyserver hkps://keys.openpgp.org --recv-keys B42F6819007F00F88E364FD4036A9C25BF357DD4; \
    gpg --batch --verify /usr/local/bin/gosu.asc /usr/local/bin/gosu; \
    gpgconf --kill all; \
    rm -rf "$GNUPGHOME" /usr/local/bin/gosu.asc; \
    chmod +x /usr/local/bin/gosu; \
    gosu --version; \
    gosu nobody true
```

## CI/CD Pipeline

### GitHub Actions Workflow Design

#### Multi-Architecture Build Workflow

```yaml
name: Docker Build and Push

on:
  push:
    branches: [main, dev]
    tags: ['v*']
  pull_request:
    branches: [main]

jobs:
  build:
    runs-on: ubuntu-latest
    strategy:
      matrix:
        version: [8, 9, 10]

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Set up Docker Buildx
        uses: docker/setup-buildx-action@v3

      - name: Login to Docker Hub
        if: github.event_name != 'pull_request'
        uses: docker/login-action@v3
        with:
          username: ${{ secrets.DOCKERHUB_USERNAME }}
          password: ${{ secrets.DOCKERHUB_TOKEN }}

      - name: Extract metadata
        id: meta
        uses: docker/metadata-action@v5
        with:
          images: snowdreamtech/rocky
          tags: |
            type=ref,event=branch,suffix=-v${{ matrix.version }}
            type=ref,event=pr,suffix=-v${{ matrix.version }}
            type=semver,pattern={{version}},suffix=-v${{ matrix.version }}
            type=semver,pattern={{major}}.{{minor}},suffix=-v${{ matrix.version }}

      - name: Build and push
        uses: docker/build-push-action@v5
        with:
          context: ./docker/${{ matrix.version }}
          platforms: linux/amd64,linux/arm64,linux/ppc64le,linux/s390x
          push: ${{ github.event_name != 'pull_request' }}
          tags: ${{ steps.meta.outputs.tags }}
          labels: ${{ steps.meta.outputs.labels }}
          cache-from: type=gha
          cache-to: type=gha,mode=max
```

#### Image Testing Workflow

```yaml
name: Docker Image Testing

on:
  workflow_run:
    workflows: ["Docker Build and Push"]
    types: [completed]

jobs:
  test:
    runs-on: ubuntu-latest
    if: ${{ github.event.workflow_run.conclusion == 'success' }}
    strategy:
      matrix:
        version: [8, 9, 10]

    steps:
      - name: Checkout
        uses: actions/checkout@v4

      - name: Test image functionality
        run: |
          # Basic functionality tests
          docker run --rm snowdreamtech/rocky:${{ matrix.version }} /bin/bash -c "echo 'Basic test passed'"

          # User mapping test
          docker run --rm -e PUID=1000 -e PGID=1000 -e USER=testuser \
            snowdreamtech/rocky:${{ matrix.version }} /bin/bash -c "id"

          # Debug mode test
          docker run --rm -e DEBUG=true \
            snowdreamtech/rocky:${{ matrix.version }} /bin/bash -c "echo 'Debug test passed'"

      - name: Security scan
        uses: aquasecurity/trivy-action@master
        with:
          image-ref: snowdreamtech/rocky:${{ matrix.version }}
          format: sarif
          output: trivy-results.sarif

      - name: Upload Trivy scan results
        uses: github/codeql-action/upload-sarif@v2
        with:
          sarif_file: trivy-results.sarif
```

### Caching Strategy

1. **Layer Caching**: Use GitHub Actions cache for Docker layers
2. **Package Cache**: Cache dnf package downloads
3. **Build Cache**: Cache intermediate build artifacts
4. **Registry Cache**: Use registry-based caching for cross-runner efficiency

## Version Management

### Rocky Linux Version-Specific Configurations

#### Rocky Linux 8.10 Configuration

```dockerfile
FROM rockylinux/rockylinux:8.10

# Version-specific packages for Rocky 8
RUN dnf -y --allowerasing install \
    redhat-lsb-core \
    procps-ng \
    sudo \
    vim-enhanced \
    # ... other packages compatible with Rocky 8
```

#### Rocky Linux 9.7 Configuration

```dockerfile
FROM rockylinux/rockylinux:9.7

# Version-specific packages for Rocky 9
RUN dnf -y --allowerasing install \
    redhat-lsb-core \
    procps-ng \
    sudo \
    vim-enhanced \
    # ... packages with Rocky 9 compatibility
```

#### Rocky Linux 10.1 Configuration

```dockerfile
FROM rockylinux/rockylinux:10.1

# Version-specific packages for Rocky 10
RUN dnf -y --allowerasing install \
    lsb-release \
    procps-ng \
    sudo \
    vim-enhanced \
    # ... latest packages for Rocky 10
```

### Version Tagging Strategy

Docker image tags follow a consistent pattern:

- **Format**: `{major}-v{major}.{minor}.{patch}`
- **Examples**:
  - `8-v8.10.0` (Rocky Linux 8.10.0)
  - `9-v9.7.0` (Rocky Linux 9.7.0)
  - `10-v10.1.0` (Rocky Linux 10.1.0)

Additional tags:

- **Latest per version**: `8`, `9`, `10`
- **Overall latest**: `latest` (points to newest Rocky version)
- **Branch tags**: `dev-8`, `dev-9`, `dev-10` for development builds

## Content Alignment

### Alpine Project Standards Alignment

#### OCI Annotations

Following alpine project patterns for comprehensive metadata:

```dockerfile
LABEL org.opencontainers.image.authors="Snowdream Tech" \
    org.opencontainers.image.title="Rocky Base Image" \
    org.opencontainers.image.description="Professional Docker Image packaging for Rocky Linux. Supports amd64, arm64, ppc64le, s390x." \
    org.opencontainers.image.documentation="https://hub.docker.com/r/snowdreamtech/rocky" \
    org.opencontainers.image.base.name="snowdreamtech/rocky:latest" \
    org.opencontainers.image.licenses="MIT" \
    org.opencontainers.image.source="https://github.com/snowdreamtech/rocky" \
    org.opencontainers.image.vendor="Snowdream Tech" \
    org.opencontainers.image.version="${VERSION}" \
    org.opencontainers.image.created="${BUILDTIME}" \
    org.opencontainers.image.revision="${REVISION}" \
    org.opencontainers.image.url="https://github.com/snowdreamtech/rocky"
```

#### Entrypoint System Alignment

Adopting alpine's modular entrypoint approach:

1. **Orchestration**: Single entrypoint script manages execution flow
2. **Modularity**: Numbered scripts in entrypoint.d/ for ordered execution
3. **Extensibility**: Easy addition of new initialization scripts
4. **Debug Support**: Comprehensive logging with DEBUG flag
5. **Signal Handling**: Proper signal forwarding for graceful shutdown

#### Package Management Alignment

While maintaining Rocky Linux specifics, align with alpine patterns:

1. **Repository Configuration**: Enable all necessary repositories upfront
2. **Package Installation**: Install packages in logical groups
3. **Cleanup**: Comprehensive cleanup of caches and temporary files
4. **Security**: GPG verification for external downloads (gosu)

### Rocky Linux System Differences

Accommodating Rocky Linux specifics while maintaining alpine alignment:

1. **Package Manager**: Use dnf instead of apk
2. **Repositories**: Configure CRB, devel, extras, and EPEL repositories
3. **User Management**: Use useradd/groupadd instead of adduser/addgroup
4. **System Tools**: Include Rocky Linux-specific tools and utilities
5. **Base Images**: Use Rocky Linux minimal images instead of alpine

## Implementation Phases

### Phase 1: Foundation Setup (Atomic Commits 1-3)

#### Commit 1: Initialize Docker Directory Structure

```bash
feat(docker): initialize multi-version directory structure

- Create docker/ root directory
- Add version subdirectories for Rocky 8, 9, 10
- Initialize .gitkeep files for directory tracking
- Set up basic directory permissions

Validates: Requirements 1.1, 2.1, 2.2
```

#### Commit 2: Migrate Base Dockerfile Templates

```bash
feat(docker): migrate and standardize Dockerfile templates

- Migrate rocky0 Dockerfile to docker/10/Dockerfile
- Create docker/8/Dockerfile for Rocky 8.10
- Create docker/9/Dockerfile for Rocky 9.7
- Standardize OCI annotations across all versions
- Implement proper base image references

Validates: Requirements 1.1, 3.1, 3.2, 3.3, 3.4, 4.1, 4.6
```

#### Commit 3: Implement Entrypoint System Migration

```bash
feat(docker): implement modular entrypoint system

- Migrate docker-entrypoint.sh with alpine-style orchestration
- Create entrypoint.d/ structure for all versions
- Implement 00-base-init.sh for system initialization
- Implement 01-base-setup.sh for user/environment setup
- Implement 99-base-end.sh for command execution
- Add comprehensive debug logging

Validates: Requirements 1.1, 4.2, 4.3, 7.1, 7.2, 7.3, 7.4, 7.5, 7.6, 7.7
```

### Phase 2: Package Management and Security (Atomic Commits 4-6)

#### Commit 4: Standardize Package Management

```bash
feat(docker): implement standardized package management

- Configure dnf repositories (CRB, devel, extras, EPEL)
- Standardize package installation across versions
- Implement proper cleanup and cache management
- Add essential development and operational tools

Validates: Requirements 8.1, 8.2, 8.3, 8.4, 8.5
```

#### Commit 5: Implement gosu Security System

```bash
feat(docker): add gosu for secure privilege dropping

- Implement architecture-aware gosu installation
- Add GPG verification for security
- Configure proper privilege dropping in entrypoint
- Test across all supported architectures

Validates: Requirements 8.6, 5.1, 5.2, 5.3, 5.4
```

#### Commit 6: Add Configuration Management

```bash
feat(docker): implement comprehensive configuration management

- Add .dockerignore files for build optimization
- Create version-specific CHANGELOG.md files
- Implement environment variable validation
- Add configuration parsing and formatting

Validates: Requirements 2.4, 11.1, 11.2, 11.3, 11.4, 11.5, 11.6
```

### Phase 3: CI/CD and Automation (Atomic Commits 7-9)

#### Commit 7: Implement Build Workflows

```bash
feat(ci): add multi-architecture build workflows

- Create GitHub Actions workflow for Docker builds
- Implement Docker Buildx for multi-architecture support
- Configure proper caching strategies
- Add automated testing integration

Validates: Requirements 6.1, 6.2, 6.3, 6.5
```

#### Commit 8: Add Testing and Security Scanning

```bash
feat(ci): implement comprehensive testing and security

- Add image functionality testing
- Implement security scanning with Trivy
- Configure automated vulnerability assessment
- Add quality gates for releases

Validates: Requirements 6.4, 12.1, 12.2, 12.3, 12.4
```

#### Commit 9: Configure Release Automation

```bash
feat(ci): add release automation and tagging

- Implement proper tagging and registry push logic
- Configure development and production builds
- Add release workflow automation
- Implement version management system

Validates: Requirements 6.6, 3.5, 3.6
```

### Phase 4: Documentation and Validation (Atomic Commits 10-12)

#### Commit 10: Create Comprehensive Documentation

```bash
docs: add comprehensive documentation suite

- Create README.md (English technical documentation)
- Create README_zh-CN.md (Chinese user documentation)
- Add migration guide and troubleshooting docs
- Document build instructions and usage examples

Validates: Requirements 10.1, 10.2, 10.3, 10.4, 10.5, 10.6
```

#### Commit 11: Implement Migration Validation

```bash
test: add migration validation and testing

- Validate file transfer completeness
- Test Docker builds for all versions and architectures
- Validate runtime functionality
- Compare with source project functionality

Validates: Requirements 12.1, 12.2, 12.3, 12.4, 12.5
```

#### Commit 12: Final Integration and Compliance

```bash
feat: complete migration with compliance validation

- Ensure AI standards compliance
- Validate conventional commit messages
- Test integration with rocky project infrastructure
- Complete migration log documentation

Validates: Requirements 9.1, 9.2, 9.3, 9.4, 9.5, 9.6, 12.6, 1.5
```

### Execution Order and Dependencies

1. **Sequential Execution**: Commits must be executed in numerical order
2. **Dependency Chain**: Each commit builds upon previous commits
3. **Validation Points**: Each commit includes validation of specific requirements
4. **Rollback Strategy**: Each commit is atomic and can be reverted independently
5. **Testing Integration**: Automated testing validates each phase completion

### Quality Assurance Checkpoints

1. **After Phase 1**: Verify directory structure and basic file migration
2. **After Phase 2**: Test package installation and security configuration
3. **After Phase 3**: Validate CI/CD workflows and automation
4. **After Phase 4**: Complete end-to-end testing and documentation review

## Error Handling

### Build Error Handling

1. **Docker Build Failures**
   - Implement retry mechanisms for network-dependent operations
   - Provide clear error messages for missing dependencies
   - Validate base image availability before build
   - Handle architecture-specific build failures gracefully

2. **Package Installation Errors**
   - Implement fallback repositories for package availability
   - Handle version-specific package differences
   - Provide clear error messages for missing packages
   - Implement proper cleanup on installation failures

3. **Migration Errors**
   - Validate source files exist before migration
   - Handle permission errors during file operations
   - Provide rollback mechanisms for failed migrations
   - Log detailed error information for troubleshooting

### Runtime Error Handling

1. **User Mapping Errors**
   - Handle conflicts with existing UIDs/GIDs
   - Provide fallback to default user when mapping fails
   - Validate PUID/PGID ranges before user creation
   - Handle permission errors gracefully

2. **Environment Configuration Errors**
   - Validate environment variable formats
   - Provide default values for missing configurations
   - Handle invalid timezone specifications
   - Validate working directory accessibility

3. **Network Configuration Errors**
   - Handle CAP_NET_BIND_SERVICE failures gracefully
   - Provide clear messages for capability requirements
   - Fall back to standard port binding when privileged ports fail

## Testing Strategy

### Testing Approach Overview

This feature uses **integration testing** and **example-based testing** rather than property-based testing, as it involves infrastructure configuration, file migration, and CI/CD setup which are not suitable for property-based testing.

### Integration Testing

1. **Docker Build Testing**
   - Test successful builds for all Rocky Linux versions (8, 9, 10)
   - Validate multi-architecture builds (amd64, arm64, ppc64le, s390x)
   - Test package installation and configuration
   - Validate final image functionality

2. **Runtime Integration Testing**
   - Test user mapping functionality with various PUID/PGID combinations
   - Validate environment variable processing
   - Test entrypoint script execution and command handling
   - Validate privilege dropping and security features

3. **CI/CD Integration Testing**
   - Test GitHub Actions workflow execution
   - Validate Docker registry push/pull operations
   - Test caching mechanisms and build optimization
   - Validate security scanning integration

### Example-Based Unit Testing

1. **Configuration Parsing Tests**
   - Test environment variable parsing with valid inputs
   - Test error handling with invalid configurations
   - Test default value assignment
   - Test configuration validation logic

2. **Migration Logic Tests**
   - Test file migration with sample directory structures
   - Test permission preservation during migration
   - Test error handling for missing source files
   - Test migration logging and reporting

3. **Entrypoint Script Tests**
   - Test script execution order and logic
   - Test debug logging functionality
   - Test signal handling and graceful shutdown
   - Test command execution and privilege dropping

### Smoke Testing

1. **Environment Setup Tests**
   - Verify Docker environment is properly configured
   - Test basic container functionality
   - Validate essential tools are available
   - Test network connectivity and repository access

2. **Migration Validation Tests**
   - Verify all required files are migrated
   - Test directory structure creation
   - Validate file permissions and ownership
   - Test git history preservation

### End-to-End Testing

1. **Complete Migration Workflow**
   - Execute full migration from rocky0 to rocky
   - Validate all Docker images build successfully
   - Test complete CI/CD pipeline execution
   - Validate final image functionality and security

2. **Cross-Platform Validation**
   - Test builds on different host architectures
   - Validate multi-architecture image functionality
   - Test deployment across different environments
   - Validate compatibility with existing infrastructure

### Security Testing

1. **Image Security Scanning**
   - Use Trivy for vulnerability assessment
   - Validate no high-severity vulnerabilities
   - Test security configuration compliance
   - Validate privilege dropping functionality

2. **Configuration Security Testing**
   - Test user mapping security boundaries
   - Validate sudo/doas configuration security
   - Test network capability restrictions
   - Validate file permission security

### Performance Testing

1. **Build Performance**
   - Measure build times across architectures
   - Test caching effectiveness
   - Validate resource usage during builds
   - Test parallel build capabilities

2. **Runtime Performance**
   - Test container startup times
   - Validate memory and CPU usage
   - Test entrypoint script performance
   - Validate network performance

This comprehensive design provides clear technical guidance for implementing all 12 requirements from the requirements document, ensuring a successful migration from rocky0 to rocky project with standardized, maintainable, and secure Docker images.

# Rocky Linux Docker Migration Guide

This document provides a comprehensive guide for migrating from the rocky0 project to the new standardized rocky project structure.

## Overview

The migration involves moving from a single-version Docker setup to a multi-version, standardized structure that supports Rocky Linux versions 8, 9, and 10 with proper architecture support and alpine-style patterns.

## Migration Summary

### Before (rocky0)
- Single Dockerfile for Rocky Linux 10.1
- Basic entrypoint system
- Limited architecture support
- Minimal CI/CD automation

### After (rocky)
- Multi-version support (8, 9, 10)
- Standardized directory structure
- Alpine-style modular entrypoint system
- Comprehensive CI/CD workflows
- Multi-architecture builds
- Enhanced security features

## Key Changes

### 1. Directory Structure

**Old Structure (rocky0):**
```
rocky0/
├── Dockerfile
├── docker-entrypoint.sh
├── entrypoint.d/
└── .dockerignore
```

**New Structure (rocky):**
```
rocky/
├── docker/
│   ├── 8/
│   │   ├── Dockerfile
│   │   ├── docker-entrypoint.sh
│   │   ├── entrypoint.d/
│   │   └── .dockerignore
│   ├── 9/
│   └── 10/
├── .github/workflows/
└── docs/
```

### 2. Base Images

| Version | Old | New |
|---------|-----|-----|
| 8 | N/A | `rockylinux/rockylinux:8.10-minimal` |
| 9 | N/A | `rockylinux/rockylinux:9.7-minimal` |
| 10 | `rockylinux/rockylinux:10.1` | `rockylinux/rockylinux:10.1-minimal` |

### 3. Tagging Strategy

**Old Tags:**
- `latest`
- `10.1`
- Version-based tags

**New Tags:**
- `8-v8.10.0`
- `9-v9.7.0`
- `10-v10.1.0`
- Version-specific latest tags

### 4. Environment Variables

#### New Variables Added:
- `PASSWORDLESS_SUDO`: Enable passwordless sudo for users
- `TZ`: Timezone configuration
- Enhanced `DEBUG` logging

#### Enhanced Variables:
- `DEBUG`: More comprehensive logging
- `USER`: Better user creation logic
- `WORKDIR`: Improved directory handling

### 5. Entrypoint System

**Enhanced Features:**
- Alpine-style orchestration
- Improved debug logging
- Better error handling
- Signal handling for graceful shutdown
- Modular script execution

### 6. Security Improvements

- GPG verification for gosu installation
- Enhanced user mapping logic
- Proper privilege dropping
- Security scanning integration
- Minimal base images

## Migration Steps

### For Users

#### 1. Update Docker Commands

**Old:**
```bash
docker run -d snowdreamtech/rocky:latest
```

**New:**
```bash
docker run -d snowdreamtech/rocky:10-v10.1.0
```

#### 2. Update Docker Compose

**Old:**
```yaml
services:
  rocky:
    image: snowdreamtech/rocky:latest
```

**New:**
```yaml
services:
  rocky:
    image: snowdreamtech/rocky:10-v10.1.0
    environment:
      - TZ=Asia/Shanghai  # New timezone support
```

#### 3. Environment Variable Updates

**Enhanced Debug Mode:**
```bash
# Old: Basic debug
docker run -e DEBUG=true snowdreamtech/rocky:latest

# New: Comprehensive debug logging
docker run -e DEBUG=true snowdreamtech/rocky:10-v10.1.0
```

**New Timezone Support:**
```bash
docker run -e TZ=Asia/Shanghai snowdreamtech/rocky:10-v10.1.0
```

### For Developers

#### 1. Build Process Changes

**Old Build:**
```bash
docker build -t rocky:local .
```

**New Build:**
```bash
# Build specific version
docker build -t rocky:local ./docker/10

# Multi-architecture build
docker buildx build \
  --platform linux/amd64,linux/arm64,linux/ppc64le,linux/s390x \
  -t rocky:local ./docker/10
```

#### 2. CI/CD Integration

The new structure includes comprehensive GitHub Actions workflows:
- Automated multi-architecture builds
- Security scanning with Trivy
- Comprehensive testing suite
- Multi-registry deployment

#### 3. Development Workflow

**Testing Multiple Versions:**
```bash
# Test Rocky 8
docker build -t rocky:8-test ./docker/8
docker run --rm rocky:8-test /bin/bash -c "cat /etc/os-release"

# Test Rocky 9
docker build -t rocky:9-test ./docker/9
docker run --rm rocky:9-test /bin/bash -c "cat /etc/os-release"

# Test Rocky 10
docker build -t rocky:10-test ./docker/10
docker run --rm rocky:10-test /bin/bash -c "cat /etc/os-release"
```

## Compatibility Matrix

### Supported Architectures by Version

| Version | amd64 | arm64 | ppc64le | s390x |
|---------|-------|-------|---------|-------|
| 8.10 | ✅ | ✅ | ✅ | ✅ |
| 9.7 | ✅ | ✅ | ✅ | ✅ |
| 10.1 | ✅ | ✅ | ✅ | ✅ |

### Package Repositories by Version

| Version | PowerTools | CRB | Devel | Extras | EPEL |
|---------|------------|-----|-------|--------|------|
| 8.10 | ✅ | ❌ | ❌ | ❌ | ✅ |
| 9.7 | ❌ | ✅ | ✅ | ✅ | ✅ |
| 10.1 | ❌ | ✅ | ✅ | ✅ | ✅ |

## Breaking Changes

### 1. Tag Format Change
- **Impact**: Existing automation using `latest` or simple version tags
- **Solution**: Update to new format (`8-v8.10.0`, `9-v9.7.0`, `10-v10.1.0`)

### 2. Base Image Change
- **Impact**: Rocky 10 now uses minimal base image
- **Solution**: Verify application compatibility with minimal image

### 3. Repository Structure
- **Impact**: Custom builds referencing root Dockerfile
- **Solution**: Update build context to version-specific directories

## Testing Your Migration

### 1. Functionality Test
```bash
# Test basic functionality
docker run --rm snowdreamtech/rocky:10-v10.1.0 \
  /bin/bash -c "echo 'Migration test passed'"

# Test user mapping
docker run --rm \
  -e PUID=1000 -e PGID=1000 -e USER=testuser \
  snowdreamtech/rocky:10-v10.1.0 \
  /bin/bash -c "id && echo 'User mapping works'"

# Test new timezone feature
docker run --rm -e TZ=Asia/Shanghai \
  snowdreamtech/rocky:10-v10.1.0 \
  /bin/bash -c "date && echo 'Timezone configuration works'"
```

### 2. Performance Test
```bash
# Compare startup times
time docker run --rm snowdreamtech/rocky:10-v10.1.0 /bin/true

# Test debug mode performance
time docker run --rm -e DEBUG=true \
  snowdreamtech/rocky:10-v10.1.0 /bin/true
```

### 3. Security Test
```bash
# Test gosu functionality
docker run --rm snowdreamtech/rocky:10-v10.1.0 \
  /bin/bash -c "gosu --version && echo 'gosu works'"

# Test privilege dropping
docker run --rm -e PUID=1000 -e PGID=1000 \
  snowdreamtech/rocky:10-v10.1.0 \
  /bin/bash -c "whoami && echo 'Privilege dropping works'"
```

## Rollback Plan

If issues are encountered during migration:

### 1. Immediate Rollback
```bash
# Use old rocky0 images temporarily
docker run -d snowdreamtech/rocky:old-tag
```

### 2. Gradual Migration
```bash
# Test new images in non-production first
docker run -d snowdreamtech/rocky:10-v10.1.0 # Test environment
# Keep old images in production until validated
```

### 3. Hybrid Approach
```bash
# Use different versions for different services
docker-compose.yml:
  service1:
    image: snowdreamtech/rocky:10-v10.1.0  # New
  service2:
    image: snowdreamtech/rocky:old-tag     # Old (temporary)
```

## Support and Resources

### Documentation
- [README.md](../README.md) - Technical documentation
- [README_zh-CN.md](../README_zh-CN.md) - Chinese user guide
- [GitHub Issues](https://github.com/snowdreamtech/rocky/issues) - Bug reports and feature requests

### Community
- [GitHub Discussions](https://github.com/snowdreamtech/rocky/discussions) - Community support
- [Project Wiki](https://github.com/snowdreamtech/rocky/wiki) - Additional documentation

### Migration Assistance
If you encounter issues during migration:
1. Check the troubleshooting section in README.md
2. Search existing GitHub issues
3. Create a new issue with migration details
4. Join community discussions for peer support

## Conclusion

The migration to the new rocky project structure provides:
- Better version management
- Enhanced security features
- Improved CI/CD automation
- Multi-architecture support
- Alpine-style best practices

While the migration requires updating tags and potentially some configuration, the benefits of the new structure significantly outweigh the migration effort.

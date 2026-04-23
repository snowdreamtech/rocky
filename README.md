# Rocky Linux Docker Images

![Docker Image Version](https://img.shields.io/docker/v/snowdreamtech/rocky)
![Docker Image Size](https://img.shields.io/docker/image-size/snowdreamtech/rocky/latest)
![Docker Pulls](https://img.shields.io/docker/pulls/snowdreamtech/rocky)
![Docker Stars](https://img.shields.io/docker/stars/snowdreamtech/rocky)

Professional Docker Image packaging for Rocky Linux. Supports multiple versions (8, 9, 10) and architectures (amd64, arm64, ppc64le, s390x).

## Supported Versions

| Version | Rocky Linux | Base Image | Tag Format | Status |
|---------|-------------|------------|------------|--------|
| 8 | 8.10 | rockylinux/rockylinux:8.10-minimal | `8-v8.10.0` | ✅ Active |
| 9 | 9.7 | rockylinux/rockylinux:9.7-minimal | `9-v9.7.0` | ✅ Active |
| 10 | 10.1 | rockylinux/rockylinux:10.1-minimal | `10-v10.1.0` | ✅ Active |

## Supported Architectures

- `linux/amd64` - x86_64 architecture
- `linux/arm64` - ARM 64-bit architecture
- `linux/ppc64le` - PowerPC 64-bit Little Endian
- `linux/s390x` - IBM System z architecture

## Quick Start

### Docker CLI

#### Basic Usage

```bash
docker run -d \
  --name=rocky \
  -e TZ=Asia/Shanghai \
  snowdreamtech/rocky:10-v10.1.0
```

#### Advanced Usage with User Mapping

```bash
docker run -d \
  --name=rocky \
  -e PUID=1000 \
  -e PGID=1000 \
  -e USER=myuser \
  -e PASSWORDLESS_SUDO=true \
  -e DEBUG=true \
  -e TZ=Asia/Shanghai \
  -v /path/to/data:/data \
  snowdreamtech/rocky:10-v10.1.0
```

### Docker Compose

```yaml
version: '3.8'

services:
  rocky:
    image: snowdreamtech/rocky:10-v10.1.0
    container_name: rocky
    environment:
      - PUID=1000
      - PGID=1000
      - USER=myuser
      - PASSWORDLESS_SUDO=true
      - DEBUG=false
      - TZ=Asia/Shanghai
      - KEEPALIVE=1
    volumes:
      - ./data:/data
    restart: unless-stopped
```

## Environment Variables

| Variable | Default | Description |
|----------|---------|-------------|
| `PUID` | `0` | User ID for file permissions |
| `PGID` | `0` | Group ID for file permissions |
| `USER` | `root` | Username to create/use |
| `PASSWORDLESS_SUDO` | `false` | Enable passwordless sudo for user |
| `KEEPALIVE` | `0` | Keep container running (1=enabled) |
| `DEBUG` | `false` | Enable debug logging |
| `UMASK` | `022` | Default file creation mask |
| `WORKDIR` | `/root` | Working directory |
| `TZ` | - | Timezone (e.g., Asia/Shanghai) |
| `CAP_NET_BIND_SERVICE` | `0` | Allow binding to privileged ports |

## Features

### Security
- **gosu Integration**: Secure privilege dropping with GPG verification
- **User Mapping**: Flexible PUID/PGID mapping for file permissions
- **Minimal Base**: Uses Rocky Linux minimal images for reduced attack surface
- **Security Scanning**: Automated vulnerability scanning with Trivy

### Architecture
- **Multi-Architecture**: Native support for amd64, arm64, ppc64le, s390x
- **Modular Entrypoint**: Alpine-style initialization system with entrypoint.d/
- **Debug Support**: Comprehensive logging with DEBUG environment variable
- **Signal Handling**: Proper signal forwarding for graceful shutdown

### Package Management
- **Repository Configuration**: Proper dnf repository setup (CRB, devel, extras, EPEL)
- **Essential Tools**: Pre-installed development and operational tools
- **Version Specific**: Optimized package selection for each Rocky Linux version
- **Clean Installation**: Comprehensive cleanup and cache management

## Build Instructions

### Prerequisites

- Docker with Buildx support
- Multi-architecture emulation (QEMU)

### Building Locally

```bash
# Build for single architecture
docker build -t rocky:local ./docker/10

# Build for multiple architectures
docker buildx build \
  --platform linux/amd64,linux/arm64,linux/ppc64le,linux/s390x \
  -t snowdreamtech/rocky:10-v10.1.0 \
  ./docker/10 \
  --push
```

### Build Arguments

| Argument | Default | Description |
|----------|---------|-------------|
| `BUILDTIME` | - | Build timestamp |
| `VERSION` | - | Image version |
| `REVISION` | - | Git revision |
| `KEEPALIVE` | `0` | Default keepalive setting |
| `DEBUG` | `false` | Default debug setting |
| `LANG` | `C.UTF-8` | Default locale |

## Development

### Project Structure

```
rocky/
├── docker/                    # Docker configurations
│   ├── 8/                    # Rocky Linux 8.x
│   │   ├── Dockerfile        # Version-specific Dockerfile
│   │   ├── docker-entrypoint.sh
│   │   ├── entrypoint.d/     # Initialization scripts
│   │   └── vimrc.local       # Vim configuration
│   ├── 9/                    # Rocky Linux 9.x
│   └── 10/                   # Rocky Linux 10.x
├── .github/workflows/         # CI/CD workflows
└── docs/                     # Documentation
```

### Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Test across all supported versions
5. Submit a pull request

### Testing

```bash
# Run basic functionality test
docker run --rm snowdreamtech/rocky:10-v10.1.0 \
  /bin/bash -c "echo 'Test passed'"

# Test user mapping
docker run --rm -e PUID=1000 -e PGID=1000 -e USER=testuser \
  snowdreamtech/rocky:10-v10.1.0 /bin/bash -c "id"

# Test debug mode
docker run --rm -e DEBUG=true \
  snowdreamtech/rocky:10-v10.1.0 /bin/bash -c "echo 'Debug test'"
```

## Troubleshooting

### Common Issues

#### Permission Denied Errors
```bash
# Ensure proper PUID/PGID mapping
docker run -e PUID=$(id -u) -e PGID=$(id -g) snowdreamtech/rocky:10-v10.1.0
```

#### Container Exits Immediately
```bash
# Enable keepalive mode
docker run -e KEEPALIVE=1 snowdreamtech/rocky:10-v10.1.0
```

#### Debug Information
```bash
# Enable debug logging
docker run -e DEBUG=true snowdreamtech/rocky:10-v10.1.0
```

### Getting Help

- **Issues**: [GitHub Issues](https://github.com/snowdreamtech/rocky/issues)
- **Discussions**: [GitHub Discussions](https://github.com/snowdreamtech/rocky/discussions)
- **Documentation**: [Project Wiki](https://github.com/snowdreamtech/rocky/wiki)

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.

## Acknowledgments

- [Rocky Linux Project](https://rockylinux.org/) for the excellent Linux distribution
- [Alpine Linux](https://alpinelinux.org/) for inspiration on container design patterns
- [gosu](https://github.com/tianon/gosu) for secure privilege dropping

## Related Projects

- [Alpine Docker Images](https://github.com/snowdreamtech/alpine)
- [Ubuntu Docker Images](https://github.com/snowdreamtech/ubuntu)
- [Debian Docker Images](https://github.com/snowdreamtech/debian)

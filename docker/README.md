# Docker Images for Rocky Linux

This directory contains Docker configurations for multiple Rocky Linux versions.

## Supported Versions

| Version | Rocky Linux | Base Image                 | Tag Format                    |
| ------- | ----------- | -------------------------- | ----------------------------- |
| 8       | 8.10        | rockylinux/rockylinux:8.10 | 8-v8.10.0, 8-latest           |
| 9       | 9.8         | rockylinux/rockylinux:9.8  | 9-v9.8.0, 9-latest            |
| 10      | 10.2        | rockylinux/rockylinux:10.2 | 10-v10.2.0, 10-latest, latest |

## Directory Structure

```
docker/
├── 8/                           # Rocky Linux 8
│   ├── Dockerfile               # Multi-stage Dockerfile
│   ├── docker-entrypoint.sh     # Container entrypoint script
│   ├── vimrc.local              # Vim configuration
│   └── entrypoint.d/            # Entrypoint scripts directory
│       ├── 00-base-init.sh      # Initialization script
│       └── 01-base-setup.sh     # Setup script (user, umask)
├── 9/                           # Rocky Linux 9
│   ├── Dockerfile               # Multi-stage Dockerfile
│   ├── docker-entrypoint.sh     # Container entrypoint script
│   ├── vimrc.local              # Vim configuration
│   └── entrypoint.d/            # Entrypoint scripts directory
│       ├── 00-base-init.sh      # Initialization script
│       └── 01-base-setup.sh     # Setup script (user, umask)
└── 10/                          # Rocky Linux 10
    ├── Dockerfile               # Multi-stage Dockerfile
    ├── docker-entrypoint.sh     # Container entrypoint script
    ├── vimrc.local              # Vim configuration
    └── entrypoint.d/            # Entrypoint scripts directory
        ├── 00-base-init.sh      # Initialization script
        └── 01-base-setup.sh     # Setup script (user, umask)
```

## Features

- **Multi-architecture support**: amd64, arm64, ppc64le, s390x (v8 supports amd64, arm64)
- **Enterprise base**: Official Rocky Linux base image
- **User management**: Support for custom PUID/PGID
- **Configurable**: Environment variables for customization
- **Entrypoint scripts**: Modular initialization system

## Environment Variables

| Variable               | Default | Description                          |
| ---------------------- | ------- | ------------------------------------ |
| `KEEPALIVE`            | 0       | Keep container running (1=yes, 0=no) |
| `CAP_NET_BIND_SERVICE` | 0       | Enable binding to privileged ports   |
| `LANG`                 | C.UTF-8 | Locale setting                       |
| `UMASK`                | 022     | File creation mask                   |
| `DEBUG`                | false   | Enable debug output                  |
| `PASSWORDLESS_SUDO`    | false   | Grant passwordless sudo to user      |
| `PGID`                 | 0       | Group ID for custom user             |
| `PUID`                 | 0       | User ID for custom user              |
| `USER`                 | root    | Username                             |
| `WORKDIR`              | /root   | Working directory                    |

## Usage

### Pull from Docker Hub

```bash
# Rocky 10 (latest)
docker pull snowdreamtech/rocky:latest
docker pull snowdreamtech/rocky:10-latest
docker pull snowdreamtech/rocky:10-v10.2.0

# Rocky 9
docker pull snowdreamtech/rocky:9-latest
docker pull snowdreamtech/rocky:9-v9.8.0

# Rocky 8
docker pull snowdreamtech/rocky:8-latest
docker pull snowdreamtech/rocky:8-v8.10.0
```

### Pull from GitHub Container Registry

```bash
# Rocky 10 (latest)
docker pull ghcr.io/snowdreamtech/rocky:latest
docker pull ghcr.io/snowdreamtech/rocky:10-latest
docker pull ghcr.io/snowdreamtech/rocky:10-v10.2.0

# Rocky 9
docker pull ghcr.io/snowdreamtech/rocky:9-latest
docker pull ghcr.io/snowdreamtech/rocky:9-v9.8.0

# Rocky 8
docker pull ghcr.io/snowdreamtech/rocky:8-latest
docker pull ghcr.io/snowdreamtech/rocky:8-v8.10.0
```

### Run Container

```bash
# Basic usage
docker run -it snowdreamtech/rocky:latest

# With custom user
docker run -it -e PUID=1000 -e PGID=1000 -e USER=myuser snowdreamtech/rocky:latest

# Keep container running
docker run -d -e KEEPALIVE=1 snowdreamtech/rocky:latest

# With debug output
docker run -it -e DEBUG=true snowdreamtech/rocky:latest
```

## Building Locally

```bash
# Build Rocky 8
docker build -t rocky:8-local docker/8/

# Build Rocky 9
docker build -t rocky:9-local docker/9/

# Build Rocky 10
docker build -t rocky:10-local docker/10/

# Build with specific platform
docker buildx build --platform linux/amd64,linux/arm64 -t rocky:10-local docker/10/
```

## Installed Packages

Each image includes the following packages:

- **System utilities**: lsb-release, procps-ng, sudo, vim-enhanced
- **Compression tools**: zip, unzip, bzip2, xz, gzip
- **File utilities**: file
- **JSON processor**: jq
- **Time zone data**: tzdata
- **Security**: openssl, gnupg2, ca-certificates
- **System monitoring**: sysstat
- **Network tools**: wget, curl, git, bind-utils, nmap-ncat, traceroute, iputils, net-tools, lsof
- **Container utilities**: libcap, gosu

## Entrypoint System

The entrypoint system executes scripts in `/usr/local/bin/entrypoint.d/` in alphabetical order:

1. **00-base-init.sh**: Initialization placeholder
2. **01-base-setup.sh**: User creation, umask configuration

## License

MIT License - see [LICENSE](../LICENSE) for details.

## Maintainer

Snowdream Tech - <https://github.com/snowdreamtech>

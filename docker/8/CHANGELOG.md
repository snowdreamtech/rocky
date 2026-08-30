# Changelog - Rocky Linux 8

All notable changes to the Rocky Linux 8 Docker image will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [8.10.0](https://github.com/snowdreamtech/rocky/compare/8-v8.10.0...8-v8.10.0) (2026-08-30)


### 🐛 Bug Fixes

* **docker:** optimize DNF configuration and repo mirrorlist handling ([168c686](https://github.com/snowdreamtech/rocky/commit/168c68616c371f5a590ef9a2d5c735b6e4bc0f7b))
* **docker:** replace EPEL placeholder domain download.example with dl.fedoraproject.org ([cb1e5f1](https://github.com/snowdreamtech/rocky/commit/cb1e5f150ca10be27f3a7079841be95c9ddb9330))

## [8.10.0](https://github.com/snowdreamtech/rocky/compare/8-v8.10.0...8-v8.10.0) (2026-08-28)


### 🐛 Bug Fixes

* **entrypoint:** unify default non-root username to appuser and restore flat script structure ([af9476c](https://github.com/snowdreamtech/rocky/commit/af9476caa64e1ad1abac45036a03bb27fa476be7))
* **entrypoint:** wrap user setup in function and default username for non-root PUID ([76bbe3e](https://github.com/snowdreamtech/rocky/commit/76bbe3eb0b9c189afbc7fe98c335eaccc7fbfd76))

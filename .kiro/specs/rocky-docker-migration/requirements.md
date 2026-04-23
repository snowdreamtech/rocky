# Requirements Document

## Introduction

This document defines the requirements for migrating Rocky Linux Docker images from the rocky0 project to the rocky project with standardized structure and content alignment. The migration involves creating a comprehensive Docker image ecosystem that supports multiple Rocky Linux versions (8, 9, 10) with proper architecture support, following established patterns from the alpine project while maintaining Rocky Linux-specific configurations.

## Glossary

- **Source_Project**: The rocky0 project containing existing Rocky Linux Docker implementation
- **Target_Project**: The rocky project that will receive the migrated and standardized code
- **Reference_Project**: The alpine project serving as the standard template for structure alignment
- **Docker_Structure**: The organized directory hierarchy containing version-specific Docker configurations
- **Base_Image**: Rocky Linux minimal container images used as foundation (e.g., rockylinux/rockylinux:10.1-minimal)
- **Version_Tag**: Three-digit version format for Docker image identification (e.g., 8.10.0, 9.7.0, 10.1.0)
- **Architecture_Support**: Multi-platform container support for different CPU architectures
- **Entrypoint_System**: Modular initialization system using docker-entrypoint.sh and entrypoint.d/ scripts
- **Migration_Scope**: The complete set of code, configurations, and workflows to be transferred and standardized
- **AI_Standards**: Coding standards, commit messages, and git workflow rules defined in rocky/.agent/rules/
- **Atomic_Execution**: Each logical change implemented and committed as a single, independent unit

## Requirements

### Requirement 1: Project Structure Migration

**User Story:** As a developer, I want to migrate effective code from rocky0 to rocky project, so that I can consolidate Docker image development in a standardized location.

#### Acceptance Criteria

1. THE Migration_System SHALL copy all effective Docker implementation code from Source_Project main branch to Target_Project dev branch
2. THE Migration_System SHALL preserve git history and authorship information during the transfer process
3. THE Migration_System SHALL exclude temporary files, build artifacts, and non-essential metadata from migration
4. THE Migration_System SHALL maintain file permissions and executable bits for shell scripts during transfer
5. THE Migration_System SHALL create a migration log documenting all transferred files and their destinations

### Requirement 2: Docker Directory Structure Standardization

**User Story:** As a developer, I want a standardized docker/ folder structure, so that I can easily manage multiple Rocky Linux versions consistently.

#### Acceptance Criteria

1. THE Docker_Structure SHALL create docker/ folder containing subdirectories for versions 8, 9, and 10
2. WHEN organizing version directories, THE Docker_Structure SHALL use numeric naming (8/, 9/, 10/) corresponding to Rocky Linux major versions
3. THE Docker_Structure SHALL place version-specific Dockerfile, docker-entrypoint.sh, and entrypoint.d/ in each version directory
4. THE Docker_Structure SHALL include .dockerignore, CHANGELOG.md files in each version directory following Reference_Project patterns
5. THE Docker_Structure SHALL maintain consistent file naming and organization across all version directories

### Requirement 3: Base Image and Version Configuration

**User Story:** As a developer, I want to use Rocky Linux minimal images with proper version tagging, so that I can ensure consistent and secure base images.

#### Acceptance Criteria

1. THE Base_Image SHALL use Rocky Linux minimal images (FROM rockylinux/rockylinux:X.Y-minimal format)
2. WHEN configuring version 8, THE Base_Image SHALL use rockylinux/rockylinux:8.10-minimal
3. WHEN configuring version 9, THE Base_Image SHALL use rockylinux/rockylinux:9.7-minimal
4. WHEN configuring version 10, THE Base_Image SHALL use rockylinux/rockylinux:10.1-minimal
5. THE Version_Tag SHALL implement three-digit format (8.10.0, 9.7.0, 10.1.0) for Docker image tags
6. THE Version_Tag SHALL support Docker image tags like 8-v8.10.0, 9-v9.7.0, 10-v10.1.0

### Requirement 4: Content Alignment with Alpine Standards

**User Story:** As a developer, I want Docker files aligned with alpine project standards, so that I can maintain consistency across different Linux distribution images.

#### Acceptance Criteria

1. THE Dockerfile SHALL follow Reference_Project structure including OCI annotations, build arguments, and environment variables
2. THE docker-entrypoint.sh SHALL implement Reference_Project patterns for initialization orchestration and debug logging
3. THE Entrypoint_System SHALL use entrypoint.d/ directory structure with numbered script execution order (00-, 01-, etc.)
4. WHILE maintaining Rocky Linux system differences, THE Entrypoint_System SHALL align script functionality with Reference_Project patterns
5. THE Dockerfile SHALL include comprehensive OCI metadata labels following Reference_Project format
6. THE Dockerfile SHALL implement proper layer optimization and package installation patterns from Reference_Project

### Requirement 5: Architecture Support Implementation

**User Story:** As a developer, I want multi-architecture support for Rocky Linux images, so that I can deploy containers across different hardware platforms.

#### Acceptance Criteria

1. THE Architecture_Support SHALL support linux/amd64, linux/arm64, linux/ppc64le, linux/s390x platforms
2. WHEN building for version 8, THE Architecture_Support SHALL include platforms available for Rocky Linux 8.10
3. WHEN building for version 9, THE Architecture_Support SHALL include platforms available for Rocky Linux 9.7
4. WHEN building for version 10, THE Architecture_Support SHALL include platforms available for Rocky Linux 10.1
5. THE Architecture_Support SHALL reference https://www.rockylinux.cn/download for platform availability verification
6. THE Architecture_Support SHALL implement platform-specific optimizations where applicable

### Requirement 6: Build Workflow and CI/CD Configuration

**User Story:** As a developer, I want automated build workflows, so that I can ensure consistent image builds across all versions and architectures.

#### Acceptance Criteria

1. THE Build_Workflow SHALL migrate and update GitHub Actions workflows from Source_Project patterns
2. THE Build_Workflow SHALL support multi-architecture builds using Docker Buildx
3. THE Build_Workflow SHALL implement proper caching strategies for build optimization
4. THE Build_Workflow SHALL include automated testing and security scanning for built images
5. THE Build_Workflow SHALL support both development and production build configurations
6. THE Build_Workflow SHALL implement proper tagging and registry push logic for different environments

### Requirement 7: Runtime Configuration and User Management

**User Story:** As a developer, I want configurable runtime parameters, so that I can customize container behavior for different deployment scenarios.

#### Acceptance Criteria

1. THE Runtime_Configuration SHALL support PUID and PGID parameters for user mapping
2. THE Runtime_Configuration SHALL support KEEPALIVE parameter for container persistence
3. THE Runtime_Configuration SHALL support DEBUG parameter for verbose logging
4. THE Runtime_Configuration SHALL support WORKDIR parameter for working directory configuration
5. THE Runtime_Configuration SHALL support UMASK parameter for file permission defaults
6. THE Runtime_Configuration SHALL implement CAP_NET_BIND_SERVICE capability configuration
7. THE Runtime_Configuration SHALL support PASSWORDLESS_SUDO parameter for privilege escalation

### Requirement 8: Security and Package Management

**User Story:** As a developer, I want secure package installation and management, so that I can ensure container security and compliance.

#### Acceptance Criteria

1. THE Package_Management SHALL use dnf package manager with proper repository configuration
2. THE Package_Management SHALL enable CRB, devel, and extras repositories for comprehensive package access
3. THE Package_Management SHALL install EPEL repository for additional package availability
4. THE Package_Management SHALL implement proper package cleanup and cache removal
5. THE Package_Management SHALL include essential development and operational tools (git, curl, vim, etc.)
6. THE Package_Management SHALL implement gosu installation for privilege dropping functionality

### Requirement 9: AI Standards Compliance

**User Story:** As a developer, I want all code to follow AI standards, so that I can maintain consistent code quality and git workflow.

#### Acceptance Criteria

1. THE AI_Standards SHALL follow all rules defined in rocky/.agent/rules/ for coding standards
2. THE AI_Standards SHALL use conventional commit messages with proper type and scope
3. THE AI_Standards SHALL implement atomic commits for each logical change
4. THE AI_Standards SHALL use English for code comments and commit messages
5. THE AI_Standards SHALL use Simplified Chinese for user-facing documentation
6. THE AI_Standards SHALL implement proper error handling and logging patterns

### Requirement 10: Documentation and Maintenance

**User Story:** As a developer, I want comprehensive documentation, so that I can understand and maintain the Docker image ecosystem.

#### Acceptance Criteria

1. THE Documentation SHALL create README.md files in English for technical reference
2. THE Documentation SHALL create README_zh-CN.md files in Simplified Chinese for user accessibility
3. THE Documentation SHALL include CHANGELOG.md files for each version tracking changes
4. THE Documentation SHALL document build instructions, usage examples, and configuration options
5. THE Documentation SHALL include troubleshooting guides and common issues resolution
6. THE Documentation SHALL maintain up-to-date version information and compatibility matrices

### Requirement 11: Parser and Serializer Requirements

**User Story:** As a developer, I want to parse Docker configuration files and environment variables, so that I can properly configure container runtime behavior.

#### Acceptance Criteria

1. WHEN a valid environment configuration is provided, THE Environment_Parser SHALL parse it into a Configuration object
2. WHEN an invalid environment configuration is provided, THE Environment_Parser SHALL return a descriptive error
3. THE Configuration_Formatter SHALL format Configuration objects back into valid environment variable format
4. FOR ALL valid Configuration objects, parsing then formatting then parsing SHALL produce an equivalent object (round-trip property)
5. THE Environment_Parser SHALL handle variations in boolean values (true/1/yes, false/0/no) consistently
6. THE Environment_Parser SHALL validate numeric values (PUID, PGID, UMASK) within acceptable ranges

### Requirement 12: Migration Validation and Testing

**User Story:** As a developer, I want validation of the migration process, so that I can ensure all functionality is preserved and improved.

#### Acceptance Criteria

1. THE Migration_Validation SHALL verify all essential files are transferred correctly
2. THE Migration_Validation SHALL test Docker image builds for all versions and architectures
3. THE Migration_Validation SHALL validate runtime functionality including user mapping and entrypoint execution
4. THE Migration_Validation SHALL compare functionality between Source_Project and migrated implementation
5. THE Migration_Validation SHALL verify compliance with AI_Standards and Reference_Project patterns
6. THE Migration_Validation SHALL test integration with existing rocky project infrastructure

#!/bin/sh
set -e

# Final execution logic for Rocky Linux 10

# Working directory setup
if [ "$DEBUG" = "true" ]; then
  echo "→ [END] Setting working directory to ${WORKDIR:-/root}"
fi
cd "${WORKDIR:-/root}"

# Command execution preparation
if [ $# -gt 0 ]; then
  if [ "$DEBUG" = "true" ]; then
    echo "→ [END] Command execution will be handled by main entrypoint"
  fi
  # Commands will be executed by main entrypoint
  exit 0
fi

# Keep-alive implementation handled by main entrypoint
if [ "$DEBUG" = "true" ]; then
  echo "→ [END] Final setup complete"
fi

#!/bin/sh
set -e

# Debug logging with alpine-style orchestration
if [ "$DEBUG" = "true" ]; then
  echo "→ [ENTRYPOINT] Executing initialization suite for Rocky Linux 9"
fi

# Execute all scripts in entrypoint.d/ with proper error handling
for script in /usr/local/bin/entrypoint.d/*; do
  if [ -x "$script" ]; then
    if [ "$DEBUG" = "true" ]; then
      echo "→ Running $(basename "$script")"
    fi
    "$script" "$@"
  else
    if [ "$DEBUG" = "true" ]; then
      echo "⚠️ Skipping $(basename "$script") (not executable)"
    fi
  fi
done

# Working directory configuration
cd "${WORKDIR:-/root}"

# Keep-alive logic with proper signal handling
if [ "${KEEPALIVE}" = "1" ]; then
  if [ "$DEBUG" = "true" ]; then
    echo "→ [ENTRYPOINT] Enabling keep-alive mode"
  fi
  trap : TERM INT
  tail -f /dev/null &
  wait
fi

# Command execution with privilege dropping
if [ $# -gt 0 ]; then
  if [ "$DEBUG" = "true" ]; then
    echo "→ [ENTRYPOINT] Executing command: $*"
  fi
  if [ "$(id -u)" = "0" ]; then
    exec gosu "${PUID:-0}:${PGID:-0}" "$@"
  else
    exec "$@"
  fi
fi

if [ "$DEBUG" = "true" ]; then
  echo "→ [ENTRYPOINT] Initialization complete"
fi

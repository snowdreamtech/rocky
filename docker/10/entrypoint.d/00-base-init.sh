#!/bin/sh
set -e

# System initialization for Rocky Linux 10

# Timezone configuration
if [ -n "${TZ}" ] && [ "$(id -u)" = "0" ]; then
  if [ -f "/usr/share/zoneinfo/${TZ}" ]; then
    if [ "$DEBUG" = "true" ]; then
      echo "→ [INIT] Setting timezone to ${TZ}"
    fi
    ln -snf "/usr/share/zoneinfo/${TZ}" /etc/localtime
    echo "${TZ}" > /etc/timezone
  else
    if [ "$DEBUG" = "true" ]; then
      echo "⚠️ [INIT] Timezone ${TZ} not found, using default"
    fi
  fi
fi

# Network capabilities configuration
if [ "${CAP_NET_BIND_SERVICE}" = "1" ] && [ "$(id -u)" = "0" ]; then
  if [ "$DEBUG" = "true" ]; then
    echo "→ [INIT] Enabling CAP_NET_BIND_SERVICE capability"
  fi
  # Enable unprivileged port binding
  sysctl -w net.ipv4.ip_unprivileged_port_start=0 2>/dev/null || true
fi

if [ "$DEBUG" = "true" ]; then
  echo "→ [INIT] System initialization complete"
fi

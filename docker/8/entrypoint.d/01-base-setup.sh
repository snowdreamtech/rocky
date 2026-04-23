#!/bin/sh
set -e

# User and environment setup for Rocky Linux 8

# User creation and mapping
if [ "$(id -u)" = "0" ] && [ "${USER}" != "root" ] && [ "${PUID:-0}" -ne 0 ]; then
  if [ "$DEBUG" = "true" ]; then
    echo "→ [SETUP] Creating user ${USER} with PUID=${PUID} PGID=${PGID}"
  fi

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
    if [ "$DEBUG" = "true" ]; then
      echo "→ [SETUP] Enabling passwordless sudo for ${USER}"
    fi
    echo "${USER} ALL=(ALL) NOPASSWD:ALL" > "/etc/sudoers.d/${USER}"
    chmod 0440 "/etc/sudoers.d/${USER}"
  fi
fi

# UMASK configuration
if [ "$DEBUG" = "true" ]; then
  echo "→ [SETUP] Setting umask to ${UMASK:-022}"
fi
umask "${UMASK:-022}"

if [ "$DEBUG" = "true" ]; then
  echo "→ [SETUP] User and environment setup complete"
fi

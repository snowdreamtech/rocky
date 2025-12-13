#!/bin/sh
set -e

# Create a user with PUID and PGID
if [ "${USER}" != "root" ] && [ ! -d "/home/${USER}" ] && [ "${PUID}" -ne 0 ] && [ "${PGID}" -ne 0 ]; then 
    groupadd -g ${PGID} ${USER}; 
    useradd -u ${PUID} -g ${PGID} -d /home/${USER} -m -s /bin/bash ${USER}; 
    # echo "${USER} ALL=(ALL) NOPASSWD:ALL" >> /etc/sudoers; 
    fi

# Enable CAP_NET_BIND_SERVICE
# if [ "${USER}" != "root" ] && [ "${CAP_NET_BIND_SERVICE}" -eq 1 ]; then
#     # setcap 'cap_net_bind_service=+ep' `which nginx`;
#     fi

# set umask
if [ -z "${UMASK}" ]; then
  UMASK=022
fi
umask "${UMASK}"
#!/bin/sh

CONFIG="luci-app-openvpn-server"
OVPN_PATH=/var/etc/openvpn-server
LOG_FILE=${OVPN_PATH}/log.log
AUTH_FILE=${OVPN_PATH}/auth
TIME="$(date "+%Y-%m-%d %H:%M:%S")"

if [ ! -r "${AUTH_FILE}" ]; then
	echo "${TIME}: Could not open password file \"${AUTH_FILE}\" for reading." >> ${LOG_FILE}
	exit 1
fi

IP=${untrusted_ip}

CORRECT_PASSWORD=$(awk '!/^;/&&!/^#/&&$1=="'${username}'"{print $2;exit}' ${AUTH_FILE})
if [ "${CORRECT_PASSWORD}" = "" ]; then 
	echo "${TIME}: ${IP} Fail authentication. username=\"${username}\", password=\"${password}\"." >> ${LOG_FILE}
	exit 1
fi

if [ "${password}" = "${CORRECT_PASSWORD}" ]; then 
	echo "${TIME}: ${IP} Successful authentication. username=\"${username}\"." >> ${LOG_FILE}
	exit 0
fi

echo "${TIME}: ${IP} Fail authentication. username=\"${username}\", password=\"${password}\"." >> ${LOG_FILE}
exit 1

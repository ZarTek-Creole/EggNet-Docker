#!/bin/bash
if [ "$(id -u)" = '0' ]; then
	export EGG_HOSTNAME=$(hostname)
	export EGG_LONG_NAME=${IRC_NETNAME}.${EGG_NICK}
	export EGG_PATH_DATA=${INSTALLDIR}/data/files/${IRC_NETNAME}
	export EGG_PATH_LOGS=${INSTALLDIR}/data/logs/${IRC_NETNAME}
	export EGG_PATH_CONF=${INSTALLDIR}/data/conf
	export EGG_PATH_TLS=${INSTALLDIR}/data/tls
	export EGG_PATH_SECRETS=${INSTALLDIR}/data/secrets
	export EGG_PATH_SCRIPTS=${INSTALLDIR}/data/scripts
	echo "export EGG_HOSTNAME=${EGG_HOSTNAME}" >> /etc/environment
	echo "export EGG_LONG_NAME=${EGG_LONG_NAME}" >> /etc/environment
	echo "export EGG_PATH_DATA=${EGG_PATH_DATA}" >> /etc/environment
	echo "export EGG_PATH_LOGS=${EGG_PATH_LOGS}" >> /etc/environment
	echo "export EGG_PATH_CONF=${EGG_PATH_CONF}" >> /etc/environment
	echo "export EGG_PATH_TLS=${EGG_PATH_TLS}" >> /etc/environment
	echo "export EGG_PATH_SECRETS=${EGG_PATH_SECRETS}" >> /etc/environment
	echo "export EGG_PATH_SCRIPTS=${EGG_PATH_SCRIPTS}" >> /etc/environment
	echo "export EGG_DISABLE_MODULES=${EGG_DISABLE_MODULES}" >> /etc/environment
	echo "export EGG_MODULES_DISABLE=${EGG_MODULES_DISABLE}" >> /etc/environment
	echo "export EGG_MODULES_ENABLE=${EGG_MODULES_ENABLE}" >> /etc/environment
	echo "export EGG_MODULES_AVAILABLE=${EGG_MODULES_AVAILABLE}" >> /etc/environment
fi

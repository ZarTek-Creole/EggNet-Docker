#!/bin/bash
if [ "$(id -u)" = '0' ]; then
	# ---- Start unofficial bash strict mode boilerplate
	# http://redsymbol.net/articles/unofficial-bash-strict-mode/
	set -o errexit  # always exit on error
	set -o errtrace # trap errors in functions as well
	set -o pipefail # don't ignore exit codes when piping output
	set -o posix    # more strict failures in subshells
	# set -x          # enable debugging

	IFS="$(printf "\n\t")"
	# ---- End unofficial bash strict mode boilerplate
	EGG_HOSTNAME="$(hostname)"
	export EGG_HOSTNAME
	export EGG_LONG_NAME="${IRC_NETNAME}.${EGG_NICK}"
	export EGG_PATH_DATA="${INSTALLDIR}/data/files/${IRC_NETNAME}"
	export EGG_PATH_LOGS="${INSTALLDIR}/data/logs/${IRC_NETNAME}"
	export EGG_PATH_CONF="${INSTALLDIR}/data/conf"
	export EGG_PATH_SECRETS="${INSTALLDIR}/data/secrets"
	export EGG_PATH_SCRIPTS="${INSTALLDIR}/data/scripts"
	{
		echo export EGG_HOSTNAME="${EGG_HOSTNAME}"
		export EGG_LONG_NAME="${EGG_LONG_NAME}"
		export EGG_PATH_DATA="${EGG_PATH_DATA}"
		export EGG_PATH_LOGS="${EGG_PATH_LOGS}"
		export EGG_PATH_CONF="${EGG_PATH_CONF}"
		export EGG_PATH_SECRETS="${EGG_PATH_SECRETS}"
		export EGG_PATH_SCRIPTS="${EGG_PATH_SCRIPTS}"
		export EGG_MODULES_ENABLE="${EGG_MODULES_ENABLE}"
		export EGG_MODULES_DISABLE="${EGG_MODULES_DISABLE}"
		export EGG_MODULES_ENABLE="${EGG_MODULES_ENABLE}"
		export EGG_MODULES_AVAILABLE="${EGG_MODULES_AVAILABLE}"
	} >> /etc/environment
fi

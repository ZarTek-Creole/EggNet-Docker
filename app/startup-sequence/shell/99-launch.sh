#!/bin/bash
if [ "$(id -u)" != '0' ]; then
	# ---- Start unofficial bash strict mode boilerplate
	# http://redsymbol.net/articles/unofficial-bash-strict-mode/
	set -o errexit  # always exit on error
	set -o errtrace # trap errors in functions as well
	set -o pipefail # don't ignore exit codes when piping output
	set -o posix    # more strict failures in subshells
	# set -x          # enable debugging

	IFS="$(printf "\n\t")"
	# ---- End unofficial bash strict mode boilerplate
	echo "RUNAS[$(id)] : /usr/bin/screen -L -Logfile "${EGG_PATH_LOGS}/${EGG_LONG_NAME}_screen.log" -S DOCKER_EGGDROP -D -m ./eggdrop -mt "${INSTALLDIR}/eggdrop.conf"
	exec /usr/bin/screen -L -Logfile "${EGG_PATH_LOGS}/${EGG_LONG_NAME}_screen.log" -S DOCKER_EGGDROP -D -m ./eggdrop -mt "${INSTALLDIR}/eggdrop.conf"
fi

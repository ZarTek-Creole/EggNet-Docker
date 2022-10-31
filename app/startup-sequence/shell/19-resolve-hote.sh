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
	echo "$(/sbin/ip route|awk '/default/ { print $3 }') hote" >> /etc/hosts
fi
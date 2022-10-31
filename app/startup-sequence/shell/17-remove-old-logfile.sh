#!/bin/bash
# ---- Start unofficial bash strict mode boilerplate
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -o errexit  # always exit on error
set -o errtrace # trap errors in functions as well
set -o pipefail # don't ignore exit codes when piping output
set -o posix    # more strict failures in subshells
# set -x          # enable debugging

IFS="$(printf "\n\t")"
# ---- End unofficial bash strict mode boilerplate
if [ -f "${EGG_PATH_LOGS}/${EGG_LONG_NAME}.log" ]; then
	rm "${EGG_PATH_LOGS}/${EGG_LONG_NAME}.log"
fi
if [ -f "${EGG_PATH_LOGS}/${EGG_LONG_NAME}_screen.log" ]; then
	rm "${EGG_PATH_LOGS}/${EGG_LONG_NAME}_screen.log"
fi
if [ -f "${EGG_PATH_LOGS}/${EGG_LONG_NAME}_raw_io.log" ]; then
	rm "${EGG_PATH_LOGS}/${EGG_LONG_NAME}_raw_io.log"
fi
if [ -f "${EGG_PATH_LOGS}/${EGG_LONG_NAME}_error.log" ]; then
	rm "${EGG_PATH_LOGS}/${EGG_LONG_NAME}_error.log"
fi
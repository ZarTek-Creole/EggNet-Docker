#!/bin/bash
# Need generate or stop ?
[ "${EGG_CONF_GENERATE}" == 0 ] && exit 0

# ---- Start unofficial bash strict mode boilerplate
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -o errexit  # always exit on error
set -o errtrace # trap errors in functions as well
set -o pipefail # don't ignore exit codes when piping output
set -o posix    # more strict failures in subshells
# set -x          # enable debugging

IFS="$(printf "\n\t")"
# ---- End unofficial bash strict mode boilerplate

# Logging file
sed -i "s@^logfile mco \* \"logs/eggdrop.log\"@logfile mco * \"${EGG_PATH_LOGS}\/${EGG_LONG_NAME}.log\"@" "${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf"
if [ "${EGG_LOG_RAW_IO}" == 1 ]; then
  sed -i 's@set raw-log 0@set raw-log 1@' "${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf"
  echo "logfile rv * \"${EGG_PATH_LOGS}/${EGG_LONG_NAME}_raw_io.log\"" >>"${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf"
fi

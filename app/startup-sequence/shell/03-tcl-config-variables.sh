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
EGG_LASTMOD=$(date +%s)
{
    echo set ::EGG_LASTMOD          "${EGG_LASTMOD}"
    set ::EGG_PATH_SECRETS		"${EGG_PATH_SECRETS}"
    set ::EGG_PATH_DATA			"${EGG_PATH_DATA}"
    set ::EGG_PATH_LOGS			"${EGG_PATH_LOGS}"
    set ::EGG_PATH_SCRIPTS		"${EGG_PATH_SCRIPTS}"
    set ::EGG_HOSTNAME			"${EGG_HOSTNAME}"
    set ::EGG_LONG_NAME			"${EGG_LONG_NAME}"
    ## VARIABLES MODULES ##
    set ::EGG_MODULES_ENABLE	"${EGG_MODULES_ENABLE}"
    set ::EGG_MODULES_DISABLE	"${EGG_MODULES_DISABLE}"
    set ::EGG_MODULES_ENABLE	"${EGG_MODULES_ENABLE}"
    set ::EGG_MODULES_AVAILABLE "${EGG_MODULES_AVAILABLE}"
} >>"${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf"

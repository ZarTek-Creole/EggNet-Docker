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


# Active .tcl and .set
sed -i 's@#unbind dcc n tcl \*dcc:tcl@bind dcc n tcl *dcc:tcl@' "${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf"
sed -i 's@#unbind dcc n set \*dcc:set@bind dcc n set *dcc:set@' "${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf"
sed -i 's@set must-be-owner 1@set must-be-owner 0@' "${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf"

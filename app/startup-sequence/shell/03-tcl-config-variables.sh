#!/bin/bash

# Do we need to generate or stop?
if [[ "$EGG_CONF_GENERATE" == 0 ]]; then
    exit 0
fi

# Write configuration settings to file
cat <<EOF >> "${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf"
set ::EGG_PATH_SECRETS          "${EGG_PATH_SECRETS}"
set ::EGG_PATH_DATA             "${EGG_PATH_DATA}"
set ::EGG_PATH_LOGS             "${EGG_PATH_LOGS}"
set ::EGG_PATH_SCRIPTS          "${EGG_PATH_SCRIPTS}"
set ::EGG_HOSTNAME              "${EGG_HOSTNAME}"
set ::EGG_LASTMOD               "$(date +%s)"
set ::EGG_LONG_NAME             "${EGG_LONG_NAME}"

## VARIABLES MODULES ##
set ::EGG_DISABLE_MODULES       "${EGG_DISABLE_MODULES}"
set ::EGG_MODULES_DISABLE       "${EGG_MODULES_DISABLE}"
set ::EGG_MODULES_ENABLE        "${EGG_MODULES_ENABLE}"
set ::EGG_MODULES_AVAILABLE     "${EGG_MODULES_AVAILABLE}"
EOF

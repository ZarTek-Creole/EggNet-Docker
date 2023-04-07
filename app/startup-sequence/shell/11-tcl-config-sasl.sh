#!/bin/bash

# Need generate or stop ?
if [ "$EGG_CONF_GENERATE" == 0 ] || [ "$EGG_SASL" == 0 ]; then
    exit 0
fi

# SASL
sed -i "s@^#set sasl-continue 1@set sasl-continue 1@" "${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf"
sed -i "s@^#set sasl 0@set sasl 1@" "${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf"
sed -i "s@^#set sasl-mechanism 0@set sasl-mechanism 2@" "${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf"
sed -i "s@^#set sasl-username \"llamabot\"@set sasl-username \"${IRC_SERVICE_USER}\"@" "${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf"
sed -i "s@^#set sasl-password \"password\"@set sasl-password \"${IRC_SERVICE_PASS}\"@" "${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf"
sed -i "s@^#set sasl-ecdsa-key \"eggdrop-ecdsa.pem\"@set sasl-ecdsa-key \"${EGG_PATH_TLS}/pem/${EGG_LONG_NAME}.pem\"@" "${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf"

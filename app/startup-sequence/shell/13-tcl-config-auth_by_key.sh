#!/bin/bash
# Activation de la possibilités de ce connecté avec lempriente digital
sed -i "s@^#set ssl-cert-auth 0@set ssl-cert-auth 1@" ${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf

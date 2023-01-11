#!/bin/bash
# Need generate or stop ?
[ $EGG_CONF_GENERATE == 0 ] && exit 0
[ $EGG_TLS_GENERATE == 0 ] && exit 0
    sed -i "s@^#set ssl-privatekey \"eggdrop.key\"@set ssl-privatekey \"${EGG_PATH_TLS}/${EGG_LONG_NAME}.key\"@" ${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf
    sed -i "s@^#set ssl-certificate \"eggdrop.crt\"@set ssl-certificate \"${EGG_PATH_TLS}/${EGG_LONG_NAME}.crt\"@" ${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf
if [ ! -f "${EGG_PATH_TLS}/${EGG_LONG_NAME}.pem" ] || [ $EGG_TLS_REGENERATE == 1 ]
then
    rm -rf ${EGG_PATH_TLS}/${EGG_LONG_NAME}.pem
    openssl ecparam -genkey -name prime256v1 -out ${EGG_PATH_TLS}/${EGG_LONG_NAME}.pem
fi

if [ ! -f "${EGG_PATH_TLS}/${EGG_LONG_NAME}.key" ] || [ $EGG_TLS_REGENERATE == 1 ]
then
    rm -rf ${EGG_PATH_TLS}/${EGG_LONG_NAME}.key
    openssl genrsa -out ${EGG_PATH_TLS}/${EGG_LONG_NAME}.key 4096
fi

if [ ! -f "${EGG_PATH_TLS}/${EGG_LONG_NAME}.crt" ] || [ $EGG_TLS_REGENERATE == 1 ]
then
    rm -rf ${EGG_PATH_TLS}/${EGG_LONG_NAME}.crt
    openssl req -new -key ${EGG_PATH_TLS}/${EGG_LONG_NAME}.key -x509 -out ${EGG_PATH_TLS}/${EGG_LONG_NAME}.crt -days 365 -batch

fi



#!/bin/bash
# Need generate or stop ?
[ $EGG_CONF_GENERATE == 0 ] && exit 0
echo "set ::EGG_PATH_SECRETS		\"${EGG_PATH_SECRETS}\""		>> ${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf
echo "set ::EGG_PATH_DATA			\"${EGG_PATH_DATA}\""			>> ${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf
echo "set ::EGG_PATH_LOGS			\"${EGG_PATH_LOGS}\""			>> ${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf
echo "set ::EGG_PATH_SCRIPTS		\"${EGG_PATH_SCRIPTS}\""		>> ${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf
echo "set ::EGG_HOSTNAME			\"${EGG_HOSTNAME}\""			>> ${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf
EGG_LASTMOD=$(date +%s)
echo "set ::EGG_LASTMOD				\"${EGG_LASTMOD}\""				>> ${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf
echo "set ::EGG_LONG_NAME			\"${EGG_LONG_NAME}\""			>> ${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf

echo "## VARIABLES MODULES ##"										>> ${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf
echo "set ::EGG_MODULES_ENABLE		\"${EGG_MODULES_ENABLE}\""		>> ${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf
echo "set ::EGG_MODULES_DISABLE		\"${EGG_MODULES_DISABLE}\""		>> ${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf
echo "set ::EGG_MODULES_ENABLE		\"${EGG_MODULES_ENABLE}\""		>> ${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf
echo "set ::EGG_MODULES_AVAILABLE	\"${EGG_MODULES_AVAILABLE}\""	>> ${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf

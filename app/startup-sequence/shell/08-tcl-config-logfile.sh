#!/bin/bash
# Need generate or stop ?
[ "$EGG_CONF_GENERATE" == 0 ] && exit 0
# Logging file
sed -i "s@^logfile mco \* \"logs/eggdrop.log\"@logfile mco * \"${EGG_PATH_LOGS}\/${EGG_LONG_NAME}.log\"@" "${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf"
if [ "${EGG_LOG_RAW_IO}" == 1 ]; then
  sed -i 's@set raw-log 0@set raw-log 1@' "${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf"
  echo "logfile rv * \"${EGG_PATH_LOGS}/${EGG_LONG_NAME}_raw_io.log\"" >>  "${EGG_PATH_CONF}/${EGG_LONG_NAME}.conf"
fi

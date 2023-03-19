#!/bin/bash
if [ "$(id -u)" != '0' ]; then
    if [ -f "${EGG_PATH_DATA}/${EGG_NICK}.user" ]; then
        echo "RUNAS[$(id)] : /usr/bin/screen -L -Logfile ${EGG_PATH_LOGS}/${EGG_LONG_NAME}_screen.log -S DOCKER_EGGDROP -D -m ./eggdrop -t ${INSTALLDIR}/eggdrop.conf"
        exec /usr/bin/screen -L -Logfile "${EGG_PATH_LOGS}/${EGG_LONG_NAME}_screen.log" -S DOCKER_EGGDROP -D -m ./eggdrop -t "${INSTALLDIR}/eggdrop.conf"
    else
        echo "RUNAS[$(id)] : /usr/bin/screen -L -Logfile ${EGG_PATH_LOGS}/${EGG_LONG_NAME}_screen.log -S DOCKER_EGGDROP -D -m ./eggdrop -mt ${INSTALLDIR}/eggdrop.conf"
        exec /usr/bin/screen -L -Logfile "${EGG_PATH_LOGS}/${EGG_LONG_NAME}_screen.log" -S DOCKER_EGGDROP -D -m ./eggdrop -mt "${INSTALLDIR}/eggdrop.conf"
    fi
fi


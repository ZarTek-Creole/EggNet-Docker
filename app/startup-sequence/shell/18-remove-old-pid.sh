#!/bin/bash
# shellcheck disable=SC2154
if [ "$(id -u)" = '0' ]; then
    if [ -e "${INSTALLDIR}/bot.pid" ]; then
        echo "Found ${INSTALLDIR}/bot.pid, removing..."
        rm -rf "${INSTALLDIR}/bot.pid"
    else
        echo "NOT Found ${INSTALLDIR}/bot.pid, removing..."
    fi
fi

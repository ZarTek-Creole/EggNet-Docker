#!/bin/bash
# Make sure $DATADIR is owned by eggdrop user. This affects ownership of the
# mounted directory on the host machine too.
# Also allow the container to be started with `--user`.
if [ "$(id -u)" = '0' ]; then
    chown -R ${UNIX_USER}:${UNIX_GROUP} "${INSTALLDIR}" || (echo "code 1" && exit 1)
    chmod 755 -R "${INSTALLDIR}" || (echo "code 2" && exit 2)
    exec su ${UNIX_USER} -c /entrypoint.sh "$@"
    exit 0
fi

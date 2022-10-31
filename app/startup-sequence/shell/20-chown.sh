#!/bin/bash
# Make sure ${DATADIR} is owned by eggdrop user. This affects ownership of the
# mounted directory on the host machine too.
# Also allow the container to be started with `--user`.
if [ "$(id -u)" = '0' ]; then
    # ---- Start unofficial bash strict mode boilerplate
    # http://redsymbol.net/articles/unofficial-bash-strict-mode/
    set -o errexit  # always exit on error
    set -o errtrace # trap errors in functions as well
    set -o pipefail # don't ignore exit codes when piping output
    set -o posix    # more strict failures in subshells
    # set -x          # enable debugging

    IFS="$(printf "\n\t")"
    # ---- End unofficial bash strict mode boilerplate
    chown -R "${USERNAME}:${USERNAME}" "${INSTALLDIR}" || (echo "code 1" && exit 1)
    chmod 755 -R "${INSTALLDIR}" || (echo "code 2" && exit 2)
    exec su "${USERNAME}" -c /entrypoint.sh "$@"
    exit 0
fi

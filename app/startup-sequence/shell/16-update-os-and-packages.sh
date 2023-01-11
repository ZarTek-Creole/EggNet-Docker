#!/bin/bash
if [ "$(id -u)" = '0' ]; then
    # ---- Start unofficial bash strict mode boilerplate
    # http://redsymbol.net/articles/unofficial-bash-strict-mode/
    set -o errexit  # always exit on error
    set -o errtrace # trap errors in functions as well
    set -o pipefail # don't ignore exit codes when piping output
    set -o posix    # more strict failures in subshells
    # set -x          # enable debugging

    echo "path-exclude /usr/share/doc/*" > /etc/dpkg/dpkg.cfg.d/docker-minimal
    echo "path-exclude /usr/share/man/*" > /etc/dpkg/dpkg.cfg.d/docker-minimal
    echo "path-exclude /usr/share/groff/*" > /etc/dpkg/dpkg.cfg.d/docker-minimal
    echo "path-exclude /usr/share/info/*" > /etc/dpkg/dpkg.cfg.d/docker-minimal
    echo "path-exclude /usr/share/lintian/*" > /etc/dpkg/dpkg.cfg.d/docker-minimal
    echo "path-exclude /usr/share/linda/*" > /etc/dpkg/dpkg.cfg.d/docker-minimal
    echo "path-exclude /usr/share/locale/*" > /etc/dpkg/dpkg.cfg.d/docker-minimal
    echo "path-exclude /usr/share/locale/*" > /etc/dpkg/dpkg.cfg.d/docker-minimal
    echo "path-include /usr/share/locale/en*" > /etc/dpkg/dpkg.cfg.d/docker-minimal

    apt-get update -qq
    apt-get upgrade -qq --yes
    apt-get install -qq -o=Dpkg::Use-Pty=0 --yes --no-install-recommends "${PKG_RUNTIME} ${PKG_EXTRA_RUNTIME}"
    # Cleaning up the apt cache
    apt-get clean
    rm -rf /var/lib/apt/lists/*
fi
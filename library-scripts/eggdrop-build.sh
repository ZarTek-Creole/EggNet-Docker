#!/usr/bin/env bash
#-------------------------------------------------------------------------------------------------------------
# Zartek Creole https://github.com/ZarTek-Creole
# Licensed. See https://github.com/ZarTek-Creole/EggNet-Docker/blob/master/LICENSE for license information.
#------------------------------------------------------------------------------------------------------------
# Syntax: ./eggdrop-build.sh [EGG_VERSION] [EGG_URL] [SOURCEDIR] [INSTALLDIR] [EGG_CONFIGURE_ARGS] [EGG_MODULES_ENABLE] [PKG_BUILDER]

set -e

EGG_VERSION=${1:-"develop"}
EGG_URL=${2:-"https://github.com/eggheads/eggdrop.git"}
SOURCEDIR=${3:-"/eggdrop-src"}
INSTALLDIR=${4:-"/eggdrop-data"}
EGG_CONFIGURE_ARGS=${5:-"--disable-ipv6 --enable-tls --enable-tdns"}
EGG_MODULES_ENABLE=${6:-"pbkdf2 blowfish dns channels server irc console"}
PKG_BUILDER=${7:-"gcc make tcl-dev libssl-dev git"}
SCRIPT_DIR="$(cd $(dirname "${BASH_SOURCE[0]}") && pwd)"
MARKER_FILE="/usr/local/etc/vscode-dev-containers/common"

echo "Packages to verify are installed: ${PKG_BUILDER}"
apt-get -y install --no-install-recommends ${PKG_BUILDER} 2> >( grep -v 'debconf: delaying package configuration, since apt-utils is not installed' >&2 )

if [ ! -d "${SOURCEDIR}" ]; then
    umask g-w,o-w
    mkdir -p ${SOURCEDIR}
    git clone --depth=1         \
        -c http.sslVerify=false \
        --branch ${EGG_VERSION} \
        -c core.eol=lf          \
        -c core.autocrlf=false  \
        -c fsck.zeroPaddedFilemode=ignore \
        -c fetch.fsck.zeroPaddedFilemode=ignore \
        -c receive.fsck.zeroPaddedFilemode=ignore \
        "${EGG_URL}" "${SOURCEDIR}" 2>&1
fi
cd ${SOURCEDIR}
EGG_MODULES_AVAILABLE=$(grep -ir 'loadmodule' eggdrop.conf | awk '{print $2}' | xargs)
EGG_MODULES_DISABLE=$(echo $EGG_MODULES_AVAILABLE)
for MODULE in ${EGG_MODULES_ENABLE}; do EGG_MODULES_DISABLE=$(echo "$EGG_MODULES_DISABLE" | sed "s/$MODULE//" | xargs) ; done
echo "List of modules disabled: ${EGG_MODULES_DISABLE}"
echo "List of modules enabled: ${EGG_MODULES_ENABLE}"
echo "List of modules available: ${EGG_MODULES_AVAILABLE}"
for DISABLE_MODULE in $(echo ${EGG_MODULES_DISABLE}); do echo "${DISABLE_MODULE}" > disabled_modules; done
echo $(cat disabled_modules) 
echo "./configure ${EGG_CONFIGURE_ARGS}" 
./configure ${EGG_CONFIGURE_ARGS}
  # Make eggdrop
make -s config 
make -s -j"$(nproc)" 
make -s install DEST=${INSTALLDIR} 
  # HASH OF COMMIT EGGDROP CURENT (BUILD) :
git rev-parse HEAD > ${INSTALLDIR}/eggdrop_commit_hash 
git branch > ${INSTALLDIR}/eggdrop_commit_name 
  # Remove builder package
# apt-get purge -y $(echo ${PKG_BUILDER}) 
# apt-get clean -qq --yes 
# apt-get autoremove --purge -qq --yes 
  # EXPORT ENV to env_builder file
set > ${INSTALLDIR}/env_builder 
mv ${INSTALLDIR}/eggdrop.conf ${INSTALLDIR}/eggdrop.conf.dist
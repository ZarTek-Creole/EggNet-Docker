#!/usr/bin/env bash

#-------------------------------------------------------------------------------------------------------------
# Zartek Creole https://github.com/ZarTek-Creole
# Licensed. See https://github.com/ZarTek-Creole/EggNet-Docker/blob/master/LICENSE for license information.
#------------------------------------------------------------------------------------------------------------
# Syntax: ./eggdrop-build.sh [EGG_VERSION] [EGG_URL] [SOURCEDIR] [INSTALLDIR] [EGG_CONFIGURE_ARGS] [EGG_MODULES_ENABLE] [PKG_BUILDER]

set -e

EGG_VERSION=${1:-'develop'}
EGG_URL=${2:-'https://github.com/eggheads/eggdrop.git'}
SOURCEDIR=${3:-'/eggdrop-src'}
INSTALLDIR=${4:-'/eggdrop-data'}
EGG_CONFIGURE_ARGS=${5:-'--disable-ipv6 --enable-tls'}
EGG_MODULES_ENABLE=${6:-'pbkdf2 blowfish dns channels server irc console'}
PKG_BUILDER=${7:-'gcc make tcl-dev libssl-dev git'}

# disable_egg_modules :
# Disable modules of eggdrop
# $1 : List of modules to enable
# $2 : List of modules to disable
# Return : List of modules disabled
function disable_egg_modules() {
    local modules_to_disable="$1"
    local modules_list="$2"

    for module in ${modules_to_disable}; do
        local regex="(^| )${module}( |$)"
        modules_list=$(echo "$modules_list" | sed -E "s/$regex//g" | xargs)
    done

    echo "$modules_list"
}
disable_egg_modules2() {
    local egg_modules_enable="$1"
    local egg_modules_disable="$2"

    # Parcourir tous les modules à activer
    for module in ${egg_modules_enable}; do
        # Remplacer le module actuel par une chaîne vide dans la liste des modules à désactiver
        egg_modules_disable=$(echo "${egg_modules_disable}" | sed "s/${module}//")
    done

    # Retourner la liste des modules désactivés
    echo "${egg_modules_disable}"
}

echo "[------>] Packages to verify are installed: ${PKG_BUILDER[*]}"
# Install builder package
# apt-get update -qq --yes 2>&1
# shellcheck disable=SC2086,SC2048
apt-get -y install --no-install-recommends ${PKG_BUILDER[*]} 2> >(grep -v 'debconf: delaying package configuration, since apt-utils is not installed' >&2) 2>&1
rm -rf "${SOURCEDIR}"
# Clone eggdrop source
if [ ! -d "${SOURCEDIR}" ]; then
    umask g-w,o-w
    mkdir -p "${SOURCEDIR}"
    git clone --depth=1                         \
    -c http.sslVerify=false                     \
    --branch "${EGG_VERSION}"                   \
    -c core.eol=lf                              \
    -c core.autocrlf=false                      \
    -c fsck.zeroPaddedFilemode=ignore           \
    -c fetch.fsck.zeroPaddedFilemode=ignore     \
    -c receive.fsck.zeroPaddedFilemode=ignore   \
    "${EGG_URL}" "${SOURCEDIR}" 2>&1
else
    echo "[XXX------>] Eggdrop source already exists"
fi

# Modules of eggdrop to enable
cd "${SOURCEDIR}"
# Extraire les modules disponibles à partir de la configuration
# Utiliser grep pour rechercher les lignes contenant "loadmodule"
# Utiliser awk pour extraire la deuxième colonne et l'option "-o" pour extraire uniquement la deuxième colonne
# Utiliser l'option "-v" pour supprimer les doublons
EGG_MODULES_AVAILABLE=$(grep -ir 'loadmodule' eggdrop.conf | awk -v 'FS= ' '/loadmodule/{print $2}' | sort -u)

EGG_MODULES_DISABLE=$EGG_MODULES_AVAILABLE

EGG_MODULES_DISABLE=$(disable_egg_modules2 "${EGG_MODULES_ENABLE}" "${EGG_MODULES_DISABLE}")
echo "[------>] List of modules disabled: ${EGG_MODULES_DISABLE}"
echo "[------>] List of modules enabled: ${EGG_MODULES_ENABLE}"
echo "[------>] List of modules available: ${EGG_MODULES_AVAILABLE}"
EGG_MODULES_DISABLE=$(disable_egg_modules "$EGG_MODULES_ENABLE" "$EGG_MODULES_DISABLE")
echo "[------>] $(cat disabled_modules)"
echo "[------>] ./configure ${EGG_CONFIGURE_ARGS}"
# shellcheck disable=SC2048,SC2086
./configure ${EGG_CONFIGURE_ARGS[*]}
# Make eggdrop
echo "[------>] $(cat Makefile)"
make -s config
make -s
make -s -j"$(nproc)"
make -s install DEST="${INSTALLDIR}"

# HASH OF COMMIT EGGDROP CURENT (BUILD) :
git rev-parse HEAD > "${INSTALLDIR}"/eggdrop_commit_hash
git branch > "${INSTALLDIR}"/eggdrop_commit_name

# Remove builder package
# apt-get purge -y $(echo ${PKG_BUILDER})
# apt-get clean -qq --yes
# apt-get autoremove --purge -qq --yes

# EXPORT ENV to env_builder file
set > "${INSTALLDIR}"/env_builder
mv "${INSTALLDIR}"/eggdrop.conf "${INSTALLDIR}"/eggdrop.conf.dist
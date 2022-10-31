#!/usr/bin/env bash
# ---- Start unofficial bash strict mode boilerplate
# http://redsymbol.net/articles/unofficial-bash-strict-mode/
set -o errexit  # always exit on error
set -o errtrace # trap errors in functions as well
set -o pipefail # don't ignore exit codes when piping output
set -o posix    # more strict failures in subshells
# set -x          # enable debugging
# shellcheck source=./create_release.conf
source ./create_release.conf || (echo "Erreur dans le fichier de configuration : ./create_release.conf" && exit)

# ---- End unofficial bash strict mode boilerplate
HUB_PASSWORD="$(cat docker_password.txt)"
LIST_OF_EGG_VERS="develop 1.9.2 1.9.0 1.8.0 1.8.4 1.6.21 1.6.0 1.5.0 1.4.0"
echo "${HUB_PASSWORD}" | docker login ghcr.io -u "${HUB_USER}" --password-stdin || exit 1
run_build() {
    echo "*** $BUILD_CMD ***"
    eval "${BUILD_CMD}" || exit
    unset BUILD_CMD

}backu
create_tag() {
    # echo docker tag "${IMAGE_NAME}:${BUILD_VERSION}" "${HUB_HOST}"/"${HUB_USER}"/"${IMAGE_NAME}:${BUILD_VERSION}" || exit 1
    # docker tag "${IMAGE_NAME}:${BUILD_VERSION}" "${HUB_HOST}"/"${HUB_USER}"/"${IMAGE_NAME}:${BUILD_VERSION}" || exit 1

    echo docker push "${HUB_HOST}"/"${HUB_USER}"/"${IMAGE_NAME}:${BUILD_VERSION}" || exit 1
    docker push "${HUB_HOST}"/"${HUB_USER}"/"${IMAGE_NAME}:${BUILD_VERSION}" || exit 1

}

echo "${BUILD_VERSION}" > LAST_BUILD_NUM
LIST_BUILD="git builder eggnet"

for EGG_VERSION in ${LIST_OF_EGG_VERS[*]}; do
    for BUILD_NAME in ${LIST_BUILD[*]}; do
        IMAGE_NAME=${BUILD_NAME,,}-"egg_vers_${EGG_VERSION}"
        TMP_BUILD_CMD="BUILD_CMD_${BUILD_NAME^^}"; BUILD_CMD=$(printf "${!TMP_BUILD_CMD}"); unset TMP_BUILD_CMD
        
        echo "*** Construction de ${IMAGE_NAME}:${BUILD_VERSION} ***"
       
        #docker rmi "${IMAGE_NAME}:${BUILD_VERSION}" "${HUB_HOST}"/"${HUB_USER}"/"${IMAGE_NAME}:${BUILD_VERSION}" || true
        run_build
        create_tag
        unset BUILD_NAME
        read -r -p "Press [Enter] key to continue..."
    done
    unset EGG_VERSION
done
unset LIST_BUILD
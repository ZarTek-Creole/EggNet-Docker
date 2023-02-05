ARG OS_NAME=debian \
    OS_VERSION=stable-slim \
    AUTHOR_MAIL="zartek.creole@gmail.com" \
    AUTHOR_NAME="ZarTek" \
    AUTHOR_WEBSITE="https://github.com/ZarTek-Creole/EggNet-Docker" \
    BUILD_DATE \
    BUILD_VERSION \
    EGG_VERS \
    HUB_NAME=eggnet \
    PKG_RUNTIME="openssl tcl screen" \
    PKG_EXTRA_RUNTIME="" \
    INSTALLDIR=/eggdrop-data \
    USER_UID=1000 \
    USER_GID=1000 \
    UNIX_USER=debian \
    UNIX_GROUP=debian



FROM eggnet-builder_gcc-latest_${EGG_VERSION}:${BUILD_VERSION} AS builder
ARG OS_NAME=debian \
    OS_VERSION=stable-slim \
    BUILD_DATE \
    BUILD_VERSION \
    EGG_VERS \
    PKG_RUNTIME="openssl tcl screen" \
    HUB_NAME \
    AUTHOR_MAIL \
    AUTHOR_NAME \
    AUTHOR_WEBSITE \
    PKG_EXTRA_RUNTIME="" \
    INSTALLDIR=/eggdrop-data \
    USER_UID=1000 \
    USER_GID=1000 \
    UNIX_USER=debian \
    UNIX_GROUP=debian

LABEL maintainer="${AUTHOR_MAIL}" \
    org.label-schema.build-date="${BUILD_DATE}" \
    eggdrop.version="${EGG_VERSION}" \
    org.opencontainers.image.source="${AUTHOR_WEBSITE}" \
    os.name="${OS_NAME}" \
    os.version="${OS_VERSION}" \
    Name="eggnet-${HUB_NAME} by ${AUTHOR_NAME}" \
    Version="${BUILD_VERSION}"

ENV INSTALLDIR=/eggdrop-data \
    EGG_NICK="EggNet" \
    EGG_OWNER="ZarTek" \
    EGG_ISMASTER="0" \
    EGG_USERNAME="" \
  EGG_LISTEN_ALL="3333"                                           \
  EGG_LISTEN_BOTS="+5555"
    EGG_LOG_RAW_IO="0" \
    EGG_CONF_GENERATE="1" \
    EGG_MODULES_ENABLE="${EGG_MODULES_ENABLE}" \
    EGG_MODULES_AVAILABLE="" \
    EGG_MODULES_DISABLE="" \
    EGG_KEEP_NICK="1" \
    IRC_CHANNELS="#Docker-EggNet" \
    IRC_PORT="+6697" \
    IRC_SERVER="irc.libera.chat" \
    IRC_NETNAME="Default" \
    PPL_USER="eggnet" \
    PPL_PASS="rootegg" \
    UNIX_USER="${UNIX_USER:-eggdrop}" \
    UNIX_GROUP="${UNIX_GROUP:-eggdrop}" \
    DEBIAN_FRONTEND=noninteractive

FROM ${OS_NAME}:${OS_VERSION} AS eggnet
ARG OS_NAME=debian \
    OS_VERSION=stable-slim \
    BUILD_DATE \
    BUILD_VERSION \
    EGG_VERSION=develop \
    EGG_VERS \
    PKG_RUNTIME="openssl tcl screen" \
    PKG_EXTRA_RUNTIME="" \
    INSTALLDIR=/eggdrop-data \
    USER_UID=1000 \
    USER_GID=1000 \
    UNIX_USER=debian \
    UNIX_GROUP=debian

RUN addgroup --system --gid ${USER_GID} ${UNIX_GROUP} \
    && adduser --quiet --disabled-password --gecos '' --system --home /eggdrop-data --no-create-home --shell /bin/bash --uid ${USER_UID} --ingroup ${UNIX_GROUP} ${USERNAME} \
    && mkdir -p /eggdrop-data/data /etc/dpkg/dpkg.cfg.d/

COPY --from=builder /eggdrop-data /eggdrop-data

RUN EGG_MODULES_AVAILABLE=$(grep -ir 'loadmodule' eggdrop.conf | awk '{print $2}' | xargs) \
    && EGG_MODULES_DISABLE=${EGG_MODULES_AVAILABLE}

RUN for MODULE in ${EGG_MODULES_ENABLE}; do EGG_MODULES_DISABLE="$(echo "${EGG_MODULES_DISABLE}" | sed "s/${MODULE}//" | xargs)" ; done \
    && echo "List of modules disabled: "${EGG_MODULES_DISABLE}"" \
    && echo "List of modules enabled: "${EGG_MODULES_ENABLE}"" \
    && echo "List of modules available: "${EGG_MODULES_AVAILABLE}""

RUN for DISABLE_MODULE in $(echo ${EGG_MODULES_DISABLE}); do echo "${DISABLE_MODULE}" > disabled_modules; done \
    && cat disabled_modules

RUN mv "/eggdrop-data/eggdrop.conf" "/eggdrop-data/eggdrop.conf.dist"

COPY app/entrypoint.sh /eggdrop-data
COPY app/startup-sequence /startup-sequence/
RUN chown -R ${USERNAME}:${UNIX_GROUP} /eggdrop-data/ \
    # Fix files right
    && chmod 0777 /entrypoint.sh /startup-sequence/*


WORKDIR /eggdrop-data
EXPOSE 3333


WORKDIR /eggdrop-data

CMD ["/entrypoint.sh"]

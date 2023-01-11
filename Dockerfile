#syntax=docker/dockerfile:1.4
ARG OS_NAME=debian
ARG OS_VERSION=stable-slim
FROM ${OS_NAME}:${OS_VERSION} AS creole_eggdrop_builder
ARG PKG_BUILDER="gcc make tcl-dev libssl-dev git"                 \
  PKG_EXTRA_BUILDER=""                                            \
  PKG_RUNTIME="openssl tcl screen"                                \
  PKG_EXTRA_RUNTIME=""                                            \
  EGG_CONFIGURE_ARGS="--disable-ipv6 --enable-tls --enable-tdns"  \
  EGG_MODULES_ENABLE="pbkdf2 blowfish dns channels server irc console" \
  EGG_VERSION=develop                                             \
  EGG_URL=https://github.com/eggheads/eggdrop.git                 \
  SOURCEDIR=/eggdrop-src                                          \
  INSTALLDIR=/eggdrop-data                                        \
  USER_UID=1000                                                   \
  USER_GID=$USER_UID                                              \
  UNIX_USER=debian                                                \
  UNIX_GROUP=debian

ENV INSTALLDIR=${INSTALLDIR}                                      \
  EGG_NICK="Docker-Egg-???"                                       \
  EGG_OWNER="ZarTek"                                              \
  EGG_ISMASTER="0"                                                \
  EGG_USERNAME=""                                                 \
  EGG_LISTEN="3333"                                               \
  EGG_LOG_RAW_IO="0"                                              \
  EGG_CONF_GENERATE="1"                                           \
  EGG_TLS_GENERATE="1"                                            \
  EGG_TLS_REGENERATE="0"                                          \
  EGG_SASL="1"                                                    \
  EGG_CAPS="1"                                                    \
  EGG_MODULES_ENABLE=${EGG_MODULES_ENABLE}                        \
  EGG_MODULES_AVAILABLE=""                                        \
  EGG_MODULES_DISABLE=""                                          \
  EGG_KEEP_NICK="1"                                               \
  IRC_CHANNELS="#docker-eggnet"                                   \
  IRC_PORT="+6697"                                                \
  IRC_SERVER="irc.libera.chat"                                    \
  IRC_NETNAME="Default"                                           \
  IRC_SERVICE_USER="eggnet"                                       \
  IRC_SERVICE_PASS="password1337"                                 \
  PPL_USER="eggnet"                                               \
  PPL_PASS="password1337"                                         \
  USER_UID="${USER_UID}"                                          \
  USER_GID="${USER_UID}"                                          \
  UNIX_USER="${UNIX_USER}"                                        \
  UNIX_GROUP="${UNIX_GROUP}"                                      \
  DEBIAN_FRONTEND=noninteractive
# Use the [Option] comment to specify true/false arguments that should appear in VS Code UX
#
# [Option] Install zsh
ARG INSTALL_ZSH="false"
# [Option] Upgrade OS packages to their latest versions
ARG UPGRADE_PACKAGES="false"

ARG INSTALL_OH_MYS="false"
ARG ADD_NON_FREE_PACKAGES="false"

# Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
COPY library-scripts/*.sh library-scripts/*.env /tmp/library-scripts/
RUN apt-get update && export DEBIAN_FRONTEND=noninteractive \
    && /bin/bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${UNIX_USER}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "${INSTALL_OH_MYS}" "${ADD_NON_FREE_PACKAGES}" \
    #
    # ****************************************************************************
    # * TODO: Add any additional OS packages you want included in the definition *
    # * here. We want to do this before cleanup to keep the "layer" small.       *
    # ****************************************************************************
    && apt-get -y install --no-install-recommends ${PKG_BUILDER} ${PKG_EXTRA_BUILDER} \
    && /bin/bash /tmp/library-scripts/eggdrop-build.sh "${EGG_VERSION}" "${EGG_URL}" "${SOURCEDIR}" "${INSTALLDIR}" "${EGG_CONFIGURE_ARGS}" "${EGG_MODULES_ENABLE}"
   # && apt-get autoremove -y && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts
LABEL maintainer="ZarTek <ZarTek.Creole@GMail.com>" \
  org.opencontainers.image.title="Eggdrop builder" \
  org.opencontainers.image.description="Eggdrop on debian" \
  org.opencontainers.image.authors="ZarTek <ZarTek.Creole@GMail.com>" \
  org.opencontainers.image.vendor="Creole Family" \
  org.opencontainers.image.documentation="https://github.com/ZarTek-Creole/docker-eggdrop" \
  org.opencontainers.image.licenses="Apache License 2.0" \
  org.opencontainers.image.version="0.0.2" \
  org.opencontainers.image.url="https://github.com/ZarTek-Creole/docker-eggdrop" \
  org.opencontainers.image.source="https://github.com/ZarTek-Creole/docker-eggdrop.git" \
  egg.version=${EGG_VERSION}


# VOLUME ${INSTALLDIR}
RUN mkdir -p ${INSTALLDIR}/data /etc/dpkg/dpkg.cfg.d/ \
  # Update APT/OS - Install runtime packages
  && apt-get update -qq \
  && apt-get upgrade -qq --yes \
  && apt-get install -qq -o=Dpkg::Use-Pty=0 --yes --no-install-recommends $(echo ${PKG_RUNTIME} ${PKG_EXTRA_RUNTIME})

WORKDIR ${INSTALLDIR}
EXPOSE 3333
COPY app/entrypoint.sh /
COPY app/docker.tcl ${INSTALLDIR}/scripts/
COPY app/startup-sequence /startup-sequence/


# Fix files right
RUN chmod 0777 /entrypoint.sh /startup-sequence/*
CMD ["/entrypoint.sh"]

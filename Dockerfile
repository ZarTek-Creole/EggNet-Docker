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
  UNIX_UID=1000                                                   \
  UNIX_GID=1000                                                   \
  UNIX_USER=debian                                                \
  UNIX_GROUP=debian

ENV INSTALLDIR=${INSTALLDIR}                                      \
  EGG_NICK="Docker-Egg-???"                                       \
  EGG_OWNER="MalaGaM"                                             \
  EGG_ISMASTER="0"                                                \
  EGG_USERNAME=""                                                 \
  EGG_LISTEN="3333"                                               \
  EGG_LOG_RAW_IO="0"                                              \
  EGG_CONF_GENERATE="1"                                           \
  EGG_MODULES_ENABLE=${EGG_MODULES_ENABLE}                        \
  EGG_MODULES_AVAILABLE=""                                        \
  EGG_MODULES_DISABLE=""                                          \
  EGG_KEEP_NICK="1"                                               \
  IRC_CHANNELS="#docker-eggnet"                                   \
  IRC_PORT="+6697"                                                \
  IRC_SERVER="irc.libera.chat"                                    \
  IRC_NETNAME="Default"                                           \
  PPL_USER="user"                                                 \
  PPL_PASS="Password"                                             \
  UNIX_USER=${UNIX_USER:-eggdrop}                                 \
  UNIX_GROUP=${UNIX_GROUP:-eggdrop}                               \
  DEBIAN_FRONTEND=noninteractive

RUN set -xvn \
  # Update APT/OS - Install builder packages 
  && sed -i -e "s@^deb http://security.debian.org/debian-security stable/updates main@# deb http://security.debian.org/debian-security stable/updates main@" /etc/apt/sources.list \
  && echo "path-exclude /usr/share/doc/*" >/etc/dpkg/dpkg.cfg.d/docker-minimal \
  && echo "path-exclude /usr/share/man/*" >>/etc/dpkg/dpkg.cfg.d/docker-minimal \
  && echo "path-exclude /usr/share/groff/*" >>/etc/dpkg/dpkg.cfg.d/docker-minimal \
  && echo "path-exclude /usr/share/info/*" >>/etc/dpkg/dpkg.cfg.d/docker-minimal \
  && echo "path-exclude /usr/share/lintian/*" >>/etc/dpkg/dpkg.cfg.d/docker-minimal \
  && echo "path-exclude /usr/share/linda/*" >>/etc/dpkg/dpkg.cfg.d/docker-minimal \
  && echo "path-exclude /usr/share/locale/*" >>/etc/dpkg/dpkg.cfg.d/docker-minimal \
  && echo "path-include /usr/share/locale/en*" >>/etc/dpkg/dpkg.cfg.d/docker-minimal \
  && apt-get update -qq \
  && apt-get upgrade -qq --yes \
  && apt-get install -qq -o=Dpkg::Use-Pty=0 --yes --no-install-recommends $(echo ${PKG_BUILDER} ${PKG_EXTRA_BUILDER}) 
  # Download eggdrop and configure source
RUN git clone -c http.sslVerify=false --branch ${EGG_VERSION} ${EGG_URL} ${SOURCEDIR} \
  && cd ${SOURCEDIR} \
  && EGG_MODULES_AVAILABLE=$(grep -ir 'loadmodule' eggdrop.conf | awk '{print $2}' | xargs) \
  && EGG_MODULES_DISABLE=$(echo $EGG_MODULES_AVAILABLE) \
  && for MODULE in ${EGG_MODULES_ENABLE}; do EGG_MODULES_DISABLE=$(echo "$EGG_MODULES_DISABLE" | sed "s/$MODULE//" | xargs) ; done \
  && echo "List of modules disabled: ${EGG_MODULES_DISABLE}" \
  && echo "List of modules enabled: ${EGG_MODULES_ENABLE}" \
  && echo "List of modules available: ${EGG_MODULES_AVAILABLE}" \
  && for DISABLE_MODULE in $(echo ${EGG_MODULES_DISABLE}); do echo "${DISABLE_MODULE}" > disabled_modules; done \
  && echo $(cat disabled_modules) \
  && echo "./configure ${EGG_CONFIGURE_ARGS}" \
  && ./configure ${EGG_CONFIGURE_ARGS} \
  # Make eggdrop
  && make -s config \
  && make -s -j"$(nproc)" \
  && make -s install DEST=${INSTALLDIR} \
  # HASH OF COMMIT EGGDROP CURENT (BUILD) :
  && git rev-parse HEAD > ${INSTALLDIR}/eggdrop_commit_hash \
  && git branch > ${INSTALLDIR}/eggdrop_commit_name \
  # Remove builder package
  && apt-get purge -y $(echo ${PKG_BUILDER}) \
  && apt-get clean -qq --yes \
  && apt-get autoremove --purge -qq --yes \
  # EXPORT ENV to env_builder file
  && set > ${INSTALLDIR}/env_builder \
  && mv ${INSTALLDIR}/eggdrop.conf ${INSTALLDIR}/eggdrop.conf.dist

LABEL maintainer="MalaGaM <MalaGaM.ARTiSPRETiS@GMail.com>" \
  org.opencontainers.image.title="Eggdrop builder" \
  org.opencontainers.image.description="Eggdrop on debian" \
  org.opencontainers.image.authors="MalaGaM <MalaGaM.ARTiSPRETiS@GMail.com>" \
  org.opencontainers.image.vendor="Creole Family" \
  org.opencontainers.image.documentation="https://github.com/MalaGaM/docker-eggdrop" \
  org.opencontainers.image.licenses="Apache License 2.0" \
  org.opencontainers.image.version="0.0.1" \
  org.opencontainers.image.url="https://github.com/MalaGaM/docker-eggdrop" \
  org.opencontainers.image.source="https://github.com/MalaGaM/docker-eggdrop.git" \
  egg.version=${EGG_VERSION} 

RUN addgroup --system --gid ${UNIX_GID} ${UNIX_GROUP} \
  && adduser --quiet --disabled-password --gecos '' --system --home ${INSTALLDIR} --no-create-home --shell /bin/bash --uid ${UNIX_UID} --ingroup ${UNIX_GROUP} ${UNIX_USER} \
  && mkdir -p ${INSTALLDIR}/data /etc/dpkg/dpkg.cfg.d/ \
  # Update APT/OS - Install runtime packages 
  && apt-get update -qq \
  && apt-get upgrade -qq --yes \
  && apt-get install -qq -o=Dpkg::Use-Pty=0 --yes --no-install-recommends $(echo ${PKG_RUNTIME} ${PKG_EXTRA_RUNTIME}) \
  && chown -R ${UNIX_USER}:${UNIX_GROUP} ${INSTALLDIR}

WORKDIR ${INSTALLDIR}
EXPOSE 3333
COPY app/entrypoint.sh /
COPY app/startup-sequence /startup-sequence/

WORKDIR ${INSTALLDIR}
# Fix files right
RUN chmod 0777 /entrypoint.sh /startup-sequence/*
CMD ["/entrypoint.sh"]


ARG EGG_VERS \
    OS_NAME=gcc \
    OS_VERSION=latest \ 
    BUILD_VERSION \ 
    GIT_OS_NAME=eggnet-git_alpine \
    GIT_OS_VERSION=latest \
    AUTHOR_MAIL="zartek.creole@gmail.com" \
    AUTHOR_NAME="ZarTek" \
    AUTHOR_WEBSITE="https://github.com/ZarTek-Creole/EggNet-Docker" \
    EGG_CONFIGURE_ARGS="--disable-ipv6 --enable-tls --enable-tdns"  \
    BUILD_DATE \
    HUB_NAME=builder \
    EGG_VERSION=develop \
    PKG_BUILD="gcc make tcl-dev libssl-dev git" \
    PKG_EXTRA_BUILD="" \
    EGG_MODULES_ENABLE="pbkdf2 blowfish dns channels server irc console" \
    EGGDROP_GITURL=https://github.com/eggheads/eggdrop.git
RUN echo "FROM eggnet-"${GIT_HUB_NAME}"_"${GIT_OS_NAME}"-"${GIT_OS_VERSION}":"${EGG_VERS}" as git"
FROM eggnet-"${GIT_HUB_NAME}"_"${GIT_OS_NAME}"-"${GIT_OS_VERSION}":"${EGG_VERS}" as git
ARG EGG_CONFIGURE_ARGS \
    BUILD_DATE \
    EGG_VERSION \
    EGG_VERS \
    BUILD_VERSION \ 
    HUB_NAME \
    AUTHOR_WEBSITE \
    AUTHOR_NAME \
    AUTHOR_MAIL \
    PKG_BUILD \
    PKG_EXTRA_BUILD \
    EGG_MODULES_ENABLE \
    EGGDROP_GITURL \
    OS_NAME \
    OS_VERSION
FROM ${OS_NAME}:${OS_VERSION} AS builder
ARG EGG_CONFIGURE_ARGS \
    BUILD_DATE \
    EGG_VERSION \
    EGG_VERS \
    HUB_NAME \
    BUILD_VERSION \ 
    AUTHOR_MAIL \
    AUTHOR_NAME \
    AUTHOR_WEBSITE \
    OS_NAME \
    OS_VERSION \
    PKG_BUILD \
    PKG_EXTRA_BUILD \
    EGG_MODULES_ENABLE

LABEL maintainer="${AUTHOR_MAIL}" \
    org.label-schema.build-date="${BUILD_DATE}" \
    eggdrop.version="${EGG_VERSION}" \
    org.opencontainers.image.source="${AUTHOR_WEBSITE}" \
    os.name="${OS_NAME}" \
    os.version="${OS_VERSION}" \
    Name="eggnet-${HUB_NAME} by ${AUTHOR_NAME}" \
    Version="${BUILD_VERSION}"



# COPY CODE SOURCE OF EGGDROP FROM GIT IMAGE TO BUILDER IMAGE
COPY --from=git /git/eggdrop-"${EGG_VERS}"/ /eggdrop-src
WORKDIR /eggdrop-src

# Update APT/OS - Install builder packages 
RUN sed -i -e "s@^deb http://security.debian.org/debian-security stable/updates main@# deb http://security.debian.org/debian-security stable/updates main@" /etc/apt/sources.list \
    && echo "path-exclude /usr/share/doc/*" >/etc/dpkg/dpkg.cfg.d/docker-minimal \
    && echo "path-exclude /usr/share/man/*" >>/etc/dpkg/dpkg.cfg.d/docker-minimal \
    && echo "path-exclude /usr/share/groff/*" >>/etc/dpkg/dpkg.cfg.d/docker-minimal \
    && echo "path-exclude /usr/share/info/*" >>/etc/dpkg/dpkg.cfg.d/docker-minimal \
    && echo "path-exclude /usr/share/lintian/*" >>/etc/dpkg/dpkg.cfg.d/docker-minimal \
    && echo "path-exclude /usr/share/linda/*" >>/etc/dpkg/dpkg.cfg.d/docker-minimal \
    && echo "path-exclude /usr/share/locale/*" >>/etc/dpkg/dpkg.cfg.d/docker-minimal \
    && echo "path-include /usr/share/locale/en*" >>/etc/dpkg/dpkg.cfg.d/docker-minimal 
RUN set -ex; \
    apt-get install -y --no-install-recommends \
    "${PKG_BUILD}" \
    "${PKG_EXTRA_BUILD}"  \
    && rm -rf /var/lib/apt/lists/*;

RUN ./configure ${EGG_CONFIGURE_ARGS}
# Make eggdrop
RUN make -s config \
    && make -s -j"$(nproc)" \
    && make -s install DEST=/eggdrop-data \
    # HASH OF COMMIT EGGDROP CURENT (BUILD) :
    && git rev-parse HEAD > /eggdrop-data/eggdrop_commit_hash \
    && git branch > /eggdrop-data/eggdrop_commit_name \
    # Remove builder package
    && apt-get purge -y  \
    "${PKG_BUILD}" \
    "${PKG_EXTRA_BUILD}"  \
    && apt-get clean -qq --yes \
    && apt-get autoremove --purge -qq --yes \
    # EXPORT ENV to env_builder file
    && set > /eggdrop-data/env_builder 





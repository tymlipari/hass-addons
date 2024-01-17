ARG BUILD_FROM
FROM $BUILD_FROM

ARG \
    BASHIO_VERSION \
    S6_OVERLAY_VERSION

# Since we're not using the Hass-provided base image,
# add some of their helpers
ENV \
    S6_BEHAVIOUR_IF_STAGE2_FAILS=2 \
    S6_CMD_WAIT_FOR_SERVICES_MAXTIME=0 \
    S6_CMD_WAIT_FOR_SERVICES=1 \
    S6_SERVICES_READYTIME=50

RUN \
    set -x \
    &&  mkdir -p /usr/src/bashio \
    &&  curl -L -f -s "https://github.com/hassio-addons/bashio/archive/v${BASHIO_VERSION}.tar.gz" \
            | tar -xzf - --strip 1 -C /usr/src/bashio \
    &&  mv /usr/src/bashio/lib /usr/lib/bashio \
    &&  ln -s /usr/lib/bashio/bashio /usr/bin/bashio \
    \
    && if [ "${BUILD_ARCH}" = "armv7" ]; then \
            export S6_ARCH="arm"; \
        elif [ "${BUILD_ARCH}" = "i386" ]; then \
            export S6_ARCH="i686"; \
        elif [ "${BUILD_ARCH}" = "amd64" ]; then \
            export S6_ARCH="x86_64"; \
        else \
            export S6_ARCH="${BUILD_ARCH}"; \
        fi \
    \
    && curl -L -f -s "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-${S6_ARCH}.tar.xz" \
        | tar Jxvf - -C / \
    && curl -L -f -s "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-noarch.tar.xz" \
        | tar Jxvf - -C / \
    && curl -L -f -s "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-arch.tar.xz" \
        | tar Jxvf - -C / \
    && curl -L -f -s "https://github.com/just-containers/s6-overlay/releases/download/v${S6_OVERLAY_VERSION}/s6-overlay-symlinks-noarch.tar.xz" \
        | tar Jxvf - -C / \
    && mkdir -p /etc/fix-attrs.d \
    && mkdir -p /etc/services.d \

COPY rootfs /
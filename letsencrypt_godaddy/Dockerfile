ARG BUILD_FROM
FROM $BUILD_FROM

# setup base
ARG \
    BUILD_ARCH \
    CRYPTOGRAPHY_VERSION \
    CERTBOT_VERSION \
    CERTBOT_DNS_GODADDY_VERSION \
    ACME_VERSION

RUN \
    set -x \
    && apk add --no-cache --update \
        libffi \
        musl \
        openssl \
    && apk add --no-cache --virtual .build-dependencies \
        build-base \
        libffi-dev \
        musl-dev \
        openssl-dev \
        cargo \
    && pip3 install --no-cache-dir --find-links \
        cryptography==${CRYPTOGRAPHY_VERSION} \
        certbot==${CERTBOT_VERSION} \
        certbot-dns-godaddy=$(CERTBOT_DNS_GODADDY_VERSION) \
        acme==${ACME_VERSION} \
    && apk del .build-dependencies

# Copy data
COPY rootfs /
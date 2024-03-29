FROM debian:bookworm-slim

ARG BUILD_SERIES=dev
ARG BUILD_ID=0

VOLUME ["/snikket"]

ENTRYPOINT ["/usr/bin/tini"]
CMD ["/bin/sh", "/entrypoint.sh"]

RUN apt-get update \
    && DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends \
        tini nginx s6 gettext-base idn2 libjs-bootstrap4 libjs-jquery \
    && rm /etc/nginx/sites-enabled/default \
    && rm -rf /var/lib/apt/lists/* \
    && apt-get autoremove -y \
    && rm -rf /var/cache/*

# Required for idn2 to work, and probably generally good
ENV LANG=C.UTF-8

ADD entrypoint.sh /entrypoint.sh
ADD render-template.sh /usr/local/bin/render-template.sh
ADD nginx/nginx.conf /etc/nginx/nginx.conf
ADD nginx/snikket-common.template /etc/nginx/templates/snikket-common
ADD nginx/startup.template /etc/nginx/templates/startup
ADD nginx/http.template /etc/nginx/templates/http
ADD nginx/https.template /etc/nginx/templates/https
ADD service /etc/sv
ADD static /var/www/html/static
ADD startup.html /var/www/html/index.html
ADD error-pages /var/www/html/_errors

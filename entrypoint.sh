#!/bin/bash

CERT_PATH="/snikket/letsencrypt/live/$SNIKKET_DOMAIN/cert.pem"

export SNIKKET_TWEAK_HTTP_PORT=${SNIKKET_TWEAK_HTTP_PORT-80}
export SNIKKET_TWEAK_HTTPS_PORT=${SNIKKET_TWEAK_HTTPS_PORT-443}
export SNIKKET_TWEAK_INTERNAL_HTTP_PORT=${SNIKKET_TWEAK_INTERNAL_HTTP_PORT-5280}
export SNIKKET_TWEAK_PORTAL_INTERNAL_HTTP_PORT=${SNIKKET_TWEAK_PORTAL_INTERNAL_HTTP_PORT-8000}

if test -f "$CERT_PATH"; then
	## Certs already exist - render and deploy configs
	for proto in http https; do
		envsubst '$SNIKKET_DOMAIN $SNIKKET_TWEAK_HTTP_PORT $SNIKKET_TWEAK_HTTPS_PORT $SNIKKET_TWEAK_INTERNAL_HTTP_PORT $SNIKKET_TWEAK_PORTAL_INTERNAL_HTTP_PORT' \
		  < /etc/nginx/templates/$proto \
		  > /etc/nginx/sites-enabled/$proto;
	done
fi

exec supervisord -c /etc/supervisord/supervisord.conf

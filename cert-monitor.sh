#!/bin/bash

CERT_PATH="/snikket/letsencrypt/live/$SNIKKET_DOMAIN/cert.pem"

export SNIKKET_TWEAK_HTTP_PORT=${SNIKKET_TWEAK_HTTP_PORT-80}
export SNIKKET_TWEAK_HTTPS_PORT=${SNIKKET_TWEAK_HTTP_PORT-443}
export SNIKKET_TWEAK_INTERNAL_HTTP_PORT=${SNIKKET_TWEAK_INTERNAL_HTTP_PORT-5280}

while sleep 10; do
	if test -f "$CERT_PATH"; then
		for proto in http https; do
			envsubst '$SNIKKET_DOMAIN $SNIKKET_TWEAK_HTTP_PORT $SNIKKET_TWEAK_HTTPS_PORT $SNIKKET_TWEAK_INTERNAL_HTTP_PORT' \
			  < /etc/nginx/templates/$proto \
			  > /etc/nginx/sites-enabled/$proto;
		done
		/usr/sbin/nginx -s reload
		exit 0;
	fi
done

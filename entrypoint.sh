#!/bin/bash

CERT_PATH="/snikket/letsencrypt/live/$SNIKKET_DOMAIN/cert.pem"

if test -f "$CERT_PATH"; then
	## Certs already exist - render and deploy configs
	for proto in http https; do
		sed "s/SNIKKET_DOMAIN/$SNIKKET_DOMAIN/g" /etc/nginx/templates/$proto \
		    > /etc/nginx/sites-enabled/$proto;
	done
fi

exec supervisord -c /etc/supervisord/supervisord.conf

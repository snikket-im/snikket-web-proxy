#!/bin/bash

CERT_PATH="/snikket/letsencrypt/live/$SNIKKET_DOMAIN/cert.pem"

while sleep 10; do
	if test -f "$CERT_PATH"; then
		for proto in http https; do
			sed "s/SNIKKET_DOMAIN/$SNIKKET_DOMAIN/g" /etc/nginx/templates/$proto \
			    > /etc/nginx/sites-enabled/$proto;
		done
		/usr/sbin/nginx -s reload
		exit 0;
	fi
done

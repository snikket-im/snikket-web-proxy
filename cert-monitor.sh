#!/bin/bash

CERT_PATH="/snikket/letsencrypt/live/$SNIKKET_DOMAIN/cert.pem"

while sleep 10; do
	if test -f "$CERT_PATH"; then
		if test -f /etc/nginx/sites-enabled/startup; then
			rm /etc/nginx/sites-enabled/startup;
		fi
		/usr/local/bin/render-template.sh "/etc/nginx/templates/snikket-common" "/etc/nginx/snippets/snikket-common.conf"
		for proto in http https; do
			/usr/local/bin/render-template.sh "/etc/nginx/templates/$proto" "/etc/nginx/sites-enabled/$proto";
		done
		/usr/sbin/nginx -s reload
		exit 0;
	fi
done

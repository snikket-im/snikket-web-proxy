#!/bin/bash

CERT_PATH="/snikket/letsencrypt/live/$SNIKKET_DOMAIN/fullchain.pem"

PROTOS="${SNIKKET_TWEAK_WEB_PROXY_PROTOS:-http https}"

if test -f "$CERT_PATH"; then
	## Certs already exist - render and deploy configs
	/usr/local/bin/render-template.sh "/etc/nginx/templates/snikket-common" "/etc/nginx/snippets/snikket-common.conf"
	for proto in $PROTOS; do
		/usr/local/bin/render-template.sh "/etc/nginx/templates/$proto" "/etc/nginx/sites-enabled/$proto";
	done
else
	/usr/local/bin/render-template.sh "/etc/nginx/templates/startup" "/etc/nginx/sites-enabled/startup";
fi

exec s6-svscan /etc/sv

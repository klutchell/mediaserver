#!/bin/sh

# restore secrets in env and yml files

secret_files="plex.env caddy.env docker-compose.yml Caddyfile"

while IFS== read -r placeholder secret || [ -n "${placeholder}" ]
do
	sed -i "s|${placeholder}|${secret}|g" ${secret_files}
done < "./secrets.env"

echo "restored secrets to ${secret_files}"

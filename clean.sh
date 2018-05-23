#!/bin/sh

# replace secrets in env and yml files

secret_files="plex.env caddy.env docker-compose.yml Caddyfile"

while IFS== read -r placeholder secret || [ -n "${placeholder}" ]
do
	sed -i "s|${secret}|${placeholder}|g" ${secret_files}
done < "./secrets.env"

echo "removed secrets from ${secret_files}"

git add ${secret_files}
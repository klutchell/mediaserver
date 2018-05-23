#!/bin/sh

while IFS== read -r placeholder secret || [ -n "${placeholder}" ]
do
	sed -i "s|${secret}|${placeholder}|g" "${1}"
done < "./secrets.env"
#!/bin/sh

while IFS== read -r placeholder secret || [ -n "${placeholder}" ]
do
	sed -i "s|${placeholder}|${secret}|g" "${1}"
done < "./secrets.env"
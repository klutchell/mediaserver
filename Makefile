SHELL = /bin/bash -e

# import a local .env file if it exists
-include .env

COMMON_FILE := docker-compose.yml
OVERRIDE_FILE := docker-compose.override.yml
DIRECT_FILE := docker-compose.direct.yml
SECURE_FILE := docker-compose.secure.yml

config: ## Write environment configuration to override file
ifneq ($(ACME_EMAIL),)
	docker-compose -f $(COMMON_FILE) -f $(SECURE_FILE) config --resolve-image-digests > $(OVERRIDE_FILE)
else
	docker-compose -f $(COMMON_FILE) -f $(DIRECT_FILE) config --resolve-image-digests > $(OVERRIDE_FILE)
endif

pull: config ## Pull tagged container images and record digests
	docker-compose pull

up: config ## Create all networks, containers, and volumes
	docker-compose up --detach --remove-orphans

deploy: up ## Alias for 'up'

down: ## Remove all networks, containers, and images
	docker-compose down --remove-orphans --rmi all

clean: ## Remove local override file
	-rm $(OVERRIDE_FILE)

help: ## Print help message
	@echo -e "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\x1b[36m\1\\x1b[m:\2/' | column -c2 -t -s :)"

.PHONY: help config pull up down clean deploy

.DEFAULT_GOAL = help

SHELL = /bin/bash -e

# import a local .env file if it exists
-include .env

COMMON_FILE := docker-compose.yml
OVERRIDE_FILE := docker-compose.override.yml
DIRECT_FILE := docker-compose.direct.yml
SECURE_FILE := docker-compose.secure.yml

ifneq ($(ACME_EMAIL),)
export COMPOSE_FILE := $(COMMON_FILE):$(SECURE_FILE)
else
export COMPOSE_FILE := $(COMMON_FILE):$(DIRECT_FILE)
endif

config: ## Write environment configuration to console
	docker-compose config

pull: ## Pull latest container images
	docker-compose pull

up: ## Create all networks, containers, and volumes
	docker-compose config > $(OVERRIDE_FILE)
	unset COMPOSE_FILE ; docker-compose up --detach --remove-orphans

deploy: up ## Alias for 'up'

pull-up: pull up ## Alias for 'pull & up'

down: ## Remove all networks, containers, and images
	docker-compose down --remove-orphans --rmi all

clean: ## Remove local override file
	-rm $(OVERRIDE_FILE)

help: ## Print help message
	@echo -e "$$(grep -hE '^\S+:.*##' $(MAKEFILE_LIST) | sed -e 's/:.*##\s*/:/' -e 's/^\(.\+\):\(.*\)/\\x1b[36m\1\\x1b[m:\2/' | column -c2 -t -s :)"

.PHONY: help config pull pull-up up down clean deploy

.DEFAULT_GOAL = help

SHELL := /usr/bin/env bash

IMAGE_NAME := blog-search_aocc-blog

.PHONY:
generate_certs:
	source scripts/generate_certs.sh

.PHONY:
up:
	docker-compose up -d --remove-orphans

.PHONY:
down:
	docker-compose down --remove-orphans

.PHONY:
rmi:
	docker rmi $(IMAGE_NAME) 

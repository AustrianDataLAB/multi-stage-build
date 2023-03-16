SHELL := /usr/bin/env bash

IMAGE_NAME := multi-stage-build-aocc-blog

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

SHELL := /usr/bin/env bash

IMAGE_NAME := multi-stage-build-aocc-blog


.PHONY:
image0:
	docker build -t $(IMAGE_NAME) -f Dockerfile .
	docker tag $(IMAGE_NAME) image0

.PHONY:
image1:
	docker build -t $(IMAGE_NAME) -f Dockerfile1 .
	docker tag $(IMAGE_NAME) image1 

.PHONY:
image2:
	docker build -t $(IMAGE_NAME) -f Dockerfile2 .
	docker tag $(IMAGE_NAME) image2 

.PHONY:
image3:
	docker build -t $(IMAGE_NAME) -f Dockerfile3 .
	docker tag $(IMAGE_NAME) image3 

.PHONY:
image4:
	docker build -t $(IMAGE_NAME) -f Dockerfile4 .
	docker tag $(IMAGE_NAME) image4 


.PHONY:
image5:
	docker build -t $(IMAGE_NAME) -f Dockerfile5 .
	docker tag $(IMAGE_NAME) image5


.PHONY:
imagetar1:
	docker build -t $(IMAGE_NAME) -f DockerfileTAR1 .
	docker tag $(IMAGE_NAME) imagetar1

.PHONY:
imagetar2:
	export DOCKER_BUILDKIT=1
	docker build --secret id=mysecret,src=mysecret -t $(IMAGE_NAME) -f DockerfileTAR2 .
	docker tag $(IMAGE_NAME) imagetar2	

#Exercise: complete this
.PHONY:
untar:
	cd dir
	chmod +x untar.sh
	docker image save 686d9b47ca92 -o tar1.tar


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

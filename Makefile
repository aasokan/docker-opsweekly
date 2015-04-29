include config/env.config

IMAGE_NAME = aasokan/ops-weekly
BIND_PORT = 81

all: docker-clean docker-build

docker-build:
	docker build -t=$(IMAGE_NAME) .

docker-run:
	docker run -e MYSQL_USER_NAME=$(MYSQL_USER_NAME) -e MYSQL_PASSWORD=$(MYSQL_PASSWORD) -e BIND_PORT=$(BIND_PORT) -p $(BIND_PORT):80 -d $(IMAGE_NAME)

docker-run-debug:
	docker run -e MYSQL_USER_NAME=$(MYSQL_USER_NAME) -e MYSQL_PASSWORD=$(MYSQL_PASSWORD) -e BIND_PORT=$(BIND_PORT) -p $(BIND_PORT):80 -i -t --entrypoint=/bin/bash $(IMAGE_NAME)

docker-clean:
	# Delete all containers
	docker rm `docker ps -a -q` > /dev/null 2>&1 || echo "No active docker runs to delete"
	# Delete all images
	docker rmi `docker images -q` > /dev/null 2>&1 || echo "No docker images to delete"
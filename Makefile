include config/env.config

IMAGE_NAME = aasokan/ops-weekly
BIND_PORT = 81

all: docker-build

docker-build:
	docker build -t=$(IMAGE_NAME) .

docker-run: docker-stop
	docker run -e MYSQL_USER_NAME=$(MYSQL_USER_NAME) -e MYSQL_PASSWORD=$(MYSQL_PASSWORD) -e BIND_PORT=$(BIND_PORT) -p $(BIND_PORT):80 $(IMAGE_NAME)

docker-run-debug: docker-stop
	docker run -e MYSQL_USER_NAME=$(MYSQL_USER_NAME) -e MYSQL_PASSWORD=$(MYSQL_PASSWORD) -e BIND_PORT=$(BIND_PORT) -p $(BIND_PORT):80 -i -t --entrypoint=/bin/bash $(IMAGE_NAME)

docker-clean:
	# Delete all containers
	docker rm `docker ps -a -q` > /dev/null 2>&1 || echo "No active docker runs to delete"
	# Delete all images
	docker rmi `docker images -q` > /dev/null 2>&1 || echo "No docker images to delete"

docker-stop:
	docker ps | grep $(IMAGE_NAME)  | cut -d' ' -f 1 | xargs docker kill > /dev/null 2>&1 || echo "No running containers"
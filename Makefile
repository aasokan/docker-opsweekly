IMAGE_NAME = aasokan/ops-weekly
BIND_PORT = 81

all: docker-clean docker-build

setup:
	$(CURDIR)/config/mysql.config.sh

docker-build:
	docker build -t=$(IMAGE_NAME) .

docker-run: setup
	docker run -e MYSQL_USER_NAME=$$MYSQL_USER_NAME -e MYSQL_PASSWORD=$$MYSQL_PASSWORD -p $(BIND_PORT):80 -d $(IMAGE_NAME)

docker-run-debug: setup
	docker run -e MYSQL_USER_NAME=$$MYSQL_USER_NAME -e MYSQL_PASSWORD=$$MYSQL_PASSWORD -p $(BIND_PORT):80 -i -t --entrypoint=/bin/bash $(IMAGE_NAME)

docker-clean:
	# Delete all containers
	docker rm `docker ps -a -q` > /dev/null 2>&1 || echo "No active docker runs to delete"
	# Delete all images
	docker rmi `docker images -q` > /dev/null 2>&1 || echo "No docker images to delete"
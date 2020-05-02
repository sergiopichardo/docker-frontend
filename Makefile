CONTAINER_NAME_DEV=frontend
CONTAINER_NAME_PROD=nginx
IMAGE_NAME=sergiopichardo/$(CONTAINER_NAME_DEV)
PORT_MAPPING_DEV=3000:3000
DOCKER_COMPOSE_DEV_FILE=docker-compose.dev.yml
# nginx listens for traffic on the external port 8080 and 
# maps it to port 80 inside the container
PORT_MAPPING=8080:80 

lint: 
	hadolint Dockerfile.dev

build-dev: 
	docker build -f Dockerfile.dev -t $(IMAGE_NAME)-dev .

build-prod: 
	docker build -t $(IMAGE_NAME) .

run-dev: 
	docker run -it -p $(PORT_MAPPING_DEV) \
	--rm --name $(CONTAINER_NAME_DEV) $(IMAGE_NAME)

run-prod: 
	docker run -it -p $(PORT_MAPPING) \
	--rm --name $(CONTAINER_NAME_PROD) $(IMAGE_NAME)

test: 
	docker exec -it $(CONTAINER_NAME_DEV) npm run test

volume: 
	docker run -it -p $(PORT_MAPPING_DEV) \
	--rm --name $(CONTAINER_NAME_DEV) \
	-v /app/node_modules \
	-v $(PWD):/app $(IMAGE_NAME) 

shell: 
	docker exec -it $(CONTAINER_NAME_DEV) sh 

clean: 
	docker system prune

dc-bd: 
	docker-compose up --build --remove-orphans

dc-up: 
	docker-compose up 

dc-bd-dev: 
	docker-compose -f $(DOCKER_COMPOSE_DEV_FILE) up --build --remove-orphans

dc-up-dev: 
	docker-compose -f $(DOCKER_COMPOSE_DEV_FILE) up --remove-orphans
	
dc-dn: 
	docker-compose down 

# --remove-orphans: this flag removes stopped containers

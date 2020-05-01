CONTAINER_NAME=frontend
IMAGE_NAME=sergiopichardo/$(CONTAINER_NAME)
PORT_MAPPING_DEV=3000:3000
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
	--rm --name $(CONTAINER_NAME) $(IMAGE_NAME)

run-prod: 
	docker run -it -p $(PORT_MAPPING) \
	--rm --name $(CONTAINER_NAME) $(IMAGE_NAME)

test: 
	docker exec -it $(CONTAINER_NAME) npm run test

volume: 
	docker run -it -p $(PORT_MAPPING_DEV) \
	--rm --name $(CONTAINER_NAME) \
	-v /app/node_modules \
	-v $(PWD):/app $(IMAGE_NAME) 

shell: 
	docker exec -it $(CONTAINER_NAME) sh 

clean: 
	docker system prune

dc-bd: 
	docker-compose up --build 

dc-up: 
	docker-compose up 
	
dc-dn: 
	docker-compose down 

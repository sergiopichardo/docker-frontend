CONTAINER_NAME=frontend
IMAGE_NAME=sergiopichardo/$(CONTAINER_NAME)
PORT_MAPPING=3000:3000

lint: 
	hadolint Dockerfile.dev

build: 
	docker build -f Dockerfile.dev -t $(IMAGE_NAME) .

run: 
	docker run -it -p $(PORT_MAPPING) \
	--rm --name $(CONTAINER_NAME) $(IMAGE_NAME)

test: 
	docker exec -it $(CONTAINER_NAME) npm run test

volume: 
	docker run -it -p $(PORT_MAPPING) \
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

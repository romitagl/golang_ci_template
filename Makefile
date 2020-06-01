SHELL := /bin/bash

# The name of the executable
TARGET := your-go-app
DOCKER_IMAGE := go-app-container
DOCKER_IMAGE_VERSION := $(shell echo `cat ./VERSION`)

.PHONY: ci
ci: all

.PHONY: ci_docker
ci_docker: config
	@echo "Building CI Docker image..."
	docker build -f ./Dockerfile  --build-arg make_target=all -t $(DOCKER_IMAGE):$(DOCKER_IMAGE_VERSION) .

.PHONY: build_docker
build_docker: config
	@echo "Building Docker image..."
	docker build -f ./Dockerfile  --build-arg make_target=build -t $(DOCKER_IMAGE):$(DOCKER_IMAGE_VERSION) .

.PHONY: run_docker
run_docker: build_docker
	@echo "Running Docker image..."
	docker run -it --name $(DOCKER_IMAGE) --rm $(DOCKER_IMAGE):$(DOCKER_IMAGE_VERSION)

.PHONY: stop_docker
stop_docker:
	@echo "Stopping Docker image..."
	docker stop $(DOCKER_IMAGE)

.PHONY: dependencies
dependencies:
	mkdir -p ./bin
	$(MAKE) --directory=./src dependencies

.PHONY: all
all: build test lint fmt cover

.PHONY: build
build: dependencies
	$(MAKE) --directory=./src build target=$(TARGET)

.PHONY: test
test: dependencies config
	$(MAKE) --directory=./src test

.PHONY: lint
lint: build
	$(MAKE) --directory=./src lint

.PHONY: fmt
fmt:
	$(MAKE) --directory=./src fmt

.PHONY: cover
cover: test
	$(MAKE) --directory=./src cover

.PHONY: clean
clean:
	rm -f ./bin/$(TARGET)
	docker rmi -f $(DOCKER_IMAGE):$(DOCKER_IMAGE_VERSION)
	$(MAKE) --directory=./src clean
	$(MAKE) --directory=./config clean

.PHONY: config
config:
	$(MAKE) --directory=./config config

.PHONY: run
run: build config
	# print app version
	./bin/$(TARGET) --version
	./bin/$(TARGET)



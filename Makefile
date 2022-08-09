SHELL := /usr/bin/env bash

project_root = $(shell git rev-parse --show-toplevel)

# GoLang version to use
GOLANG_VERSION=1.19-buster

# The name of the executable
TARGET := your-go-app
DOCKER_IMAGE := go-app-container
DOCKER_IMAGE_VERSION := $(shell git rev-parse HEAD)

export GOPROXY?=https://proxy.golang.org/

.PHONY: help
help: ## Display this help
	@awk 'BEGIN {FS = ":.*##"; printf "\nUsage:\n  make \033[36m<target>\033[0m\n"} /^[a-zA-Z_0-9-]+:.*?##/ { printf "  \033[36m%-15s\033[0m %s\n", $$1, $$2 } /^##@/ { printf "\n\033[1m%s\033[0m\n", substr($$0, 5) } ' $(MAKEFILE_LIST)

.PHONY: ci
ci: all

.PHONY: ci_docker
ci_docker:
	@echo "Building CI Docker image..."
	docker build -f ./Dockerfile --build-arg golang_version=$(GOLANG_VERSION) --build-arg make_target=all -t $(DOCKER_IMAGE):$(DOCKER_IMAGE_VERSION) .

.PHONY: build_docker
build_docker:
	@echo "Building Docker image..."
	docker build -f ./Dockerfile  --build-arg golang_version=$(GOLANG_VERSION) --build-arg make_target=build -t $(DOCKER_IMAGE):$(DOCKER_IMAGE_VERSION) .

.PHONY: run_docker
run_docker: build_docker
	@echo "Running Docker image..."
	docker run -it --name $(DOCKER_IMAGE) --rm $(DOCKER_IMAGE):$(DOCKER_IMAGE_VERSION)

.PHONY: run_golang_docker
run_golang_docker:
	@echo "Running Docker image..."
	docker run -it --rm --name golang -v $(project_root)/:/app golang:$(GOLANG_VERSION) bash -c 'cd /app && make all'
	# bash -c 'cd /app && make all'

.PHONY: stop_docker
stop_docker:
	@echo "Stopping Docker image..."
	docker stop $(DOCKER_IMAGE)

.PHONY: dependencies
dependencies:
	go mod tidy
	go install -v ./...

.PHONY: all
all: fmt lint build test cover

.PHONY: build
build: dependencies
	bash ./build_script.sh $(TARGET)

.PHONY: install
install: build ## Build and install the binary with the current source code. Use it to test your changes locally.
	cp ./bin/$(TARGET) $(GOBIN)/$(TARGET)

.PHONY: test
test: dependencies
	@echo "Running tests..."
	go test ./... -v -timeout=30s -parallel=4 -bench=. -benchmem -cover -coverprofile=cover.out

.PHONY: lint
lint: build
	@echo "Running linter..."
	go vet ./... 
	go install github.com/golangci/golangci-lint/cmd/golangci-lint@latest
	golangci-lint run
	go install honnef.co/go/tools/cmd/staticcheck@latest
	staticcheck ./...

.PHONY: fmt
fmt:
	@echo "Running fmt..."
	go fmt ./...

.PHONY: cover
cover: test
	@echo "Running code coverage..."
	go tool cover -html cover.out -o coverage.html 

.PHONY: clean
clean:
	rm -f ./bin/$(TARGET)
	docker rmi -f $(DOCKER_IMAGE):$(DOCKER_IMAGE_VERSION)
	go clean
	rm -f ./cover.out ./coverage.html 

.PHONY: run
run: build
	# print app version
	./bin/$(TARGET) --version
	./bin/$(TARGET)

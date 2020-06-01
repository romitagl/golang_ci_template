SHELL := /bin/bash

.PHONY: dependencies
dependencies:
	go mod tidy
	#go get -v -t -d ./...

.PHONY: test
test:
	@echo "Running tests..."
	go test ./... -v -timeout=30s -parallel=4 -bench=. -benchmem -cover -coverprofile=cover.out

.PHONY: lint
lint:
	@echo "Running linter..."
	go vet ./... 
	go get -u golang.org/x/lint/golint 
	golint -set_exit_status ./...

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
	go clean
	rm -f ./go.sum
	rm -f ./cover.out ./coverage.html 

.PHONY: build
build:
	# target is a make parameter from the main Makefile
	bash ./build_script.sh $(target)




#!/bin/bash

#@ Build
LD_FLAGS="\
    -X main.versionNo=$(git describe --tags --dirty --broken) \
    -X main.goos=$(go env GOOS) \
    -X main.goarch=$(go env GOARCH) \
    -X main.gitCommit=$(git rev-parse HEAD) \
    -X main.buildDate=$(date -u +'%Y-%m-%dT%H:%M:%SZ') \
    "

echo "Building go executable in the ./bin folder"
mkdir -p ./bin
go build -ldflags "$LD_FLAGS" -buildmode=exe -v -o ./bin/$1

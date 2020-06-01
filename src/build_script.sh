#!/bin/bash

# gets version number from version file in root of project
versionNo=$(cat ../VERSION)

# Get todays date
now=$(date +'%Y-%m-%d_%T')

go build -ldflags "-X main.versionNo=$versionNo -X main.buildTime=$now" -buildmode=exe -v -o ../bin/$1 main.go

# Description

This project can be used as base template to easily start writing **your-go-app** with the support of a CI-CD pipeline [*GitHub Actions*](https://github.com/features/actions) that includes testing, linting and code coverage.

Pipeline can be run in your development environment or directly in GitHub.

## Workflows status

![CI](https://github.com/romitagl/golang_ci_template/workflows/CI%20Pipeline/badge.svg)

![CD](https://github.com/romitagl/golang_ci_template/workflows/CD%20Pipeline/badge.svg)

## Features

Application currently supports:

- Input parameters
  - `-version`: print out the version number and build date of the program
  - `-config`: custom path to the yaml config file
- YAML Configuration file
  - `./config/config.yaml` (default path)
- Environment variables
  - `APP_MAIN_SLEEP`: overrides *runtime:main-sleep* yaml param
  - `APP_LOG_TRACING_ON`: overrides *runtime:log-tracing* yaml param

**CI** currently supports:

- Building: `go build`
- Testing: `go test`
- Linting: `go vet`
- Code Formatting: `go fmt`
- Code Coverage: `go tool cover` - output report ./src/coverage.html

**CD** currently supports:

- Publishing the Docker container (`go-app-container`) to [GitHub Packages](docker.pkg.github.com)

## Structure

`tree .`:

```bash
.
├── Dockerfile
├── LICENSE
├── Makefile # specifies the *your-go-app* target
├── README.md
├── bin
│   └── your-go-app
├── build_script.sh
├── config
│   └── config.yaml
├── cover.out
├── coverage.html
├── go.mod # specifies the *your-go-app* module
├── go.sum
├── main.go
└── manager
    ├── config.go
    └── config_test.go
```

Makefile targets can be run the code in a containerized environment (Docker) or natively.

## Dependencies

- [Docker](https://www.docker.com)
- [GNU Make](https://www.gnu.org/software/make/)

Software is built using **Go 1.19**

## Quick spin

Run `make run` in the command line when having the `Golang` installed or `make run_docker` for building inside a container.

### How-To-Run

Run `make run` or the single steps manually:

```bash
# to build the software when not having the binary distribution
make build
# to run 
make run
```

A **Docker** environment is also available for building the software.

```bash
# to build
make build_docker
```

## CI targets

Run natively on your machine:

```bash
# run all the CI targets (build test lint fmt cover)
make ci
```

Run in a Docker container:

```bash
# run all the CI targets (build test lint fmt cover)
make run_golang_docker
# run all the CI targets (build test lint fmt cover) and build the Docker container
make ci_docker
```

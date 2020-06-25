# Description

This project can be used as base template to easily start writing **your-go-app** with the support of a CI-CD pipeline [*GitHub Actions*](https://github.com/features/actions) that includes testing, linting and code coverage.

Pipeline can be run in your development environment or directly in GitHub.

## Workflows status
![](https://github.com/romitagl/golang_ci_template/workflows/CI%20Pipeline/badge.svg)
![](https://github.com/romitagl/golang_ci_template/workflows/CD%20Pipeline/badge.svg)

# Features

Application currently supports:
- Input parameters
  - `-version`: print out the version number and build date of the program 
  - `-config`: custom path to the yaml config file
- Generated YAML Configuration file - based on [template](./config/config-template.yaml) 
  - `./config/config.yaml` (default path)
- Environment variables 
  - `APP_MAIN_SLEEP`: overrides *runtime:main-sleep* yaml param
  - `APP_LOG_TRACING_ON`: overrides *runtime:log-tracing* yaml param
- Build version - from [VERSION](./VERSION) file

**CI** currently supports:
- Building: `go build`
- Testing: `go test`
- Linting: `go vet`
- Code Formatting: `go fmt`
- Code Coverage: `go tool cover` - output report ./src/coverage.html

**CD** currently supports:
- Publishing the Docker container (`go-app-container`) to [GitHub Packages](docker.pkg.github.com)

# Structure

`tree .`:

```bash
.
├── bin # binary file folder
├── config # configuration folder
│   ├── config-template.yaml
│   ├── create_config.sh # creates the config.yaml replacing the env variables with the actual values
│   └── Makefile
├── Dockerfile
├── Makefile # specifies the *your-go-app* target
├── README.md
├── src # source code for the app
│   ├── build_script.sh
│   ├── go.mod
│   ├── main.go
│   ├── Makefile
│   └── manager # go package
│       ├── config.go
│       └── config_test.go
└── VERSION # version file used at build time

```

Makefile targets can be run the code in a containerized environment (Docker) or natively.

## Dependencies
- [Docker](https://www.docker.com) 
- [GNU Make](https://www.gnu.org/software/make/)

Software is built using **Go 1.13** 

## Quick spin

Run `make run` in the command line when having the `Golang` installed or `make run_docker` for building inside a container.

### How-To-Run

Run `make run` or the single steps manually:

```bash
# to build the software when not having the binary distribution
make build
# to run - also updates the Hasura (Postgresql) configuration
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
make ci_docker
```
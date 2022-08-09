# -- BUILD STAGE --
ARG golang_version
# https://hub.docker.com/_/golang/
FROM golang:${golang_version} as development

# input parameter (Makefile target)
ARG make_target

RUN mkdir /app 
# copying everything to the container as this is a BUILD ONLY IMAGE
ADD . /app/
WORKDIR /app 

RUN make $make_target

# -- RELEASE STAGE --
ARG golang_version
FROM golang:${golang_version}

RUN mkdir /app

WORKDIR /app/

# Copy the executable from the previous stage
RUN echo "copy the executable"
COPY --from=development /app/bin/your-go-app .
COPY --from=development /app/config/config.yaml ./config/config.yaml

ENTRYPOINT ["./your-go-app"]
# CMD ["--version"]

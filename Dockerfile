# -- BUILD STAGE --

# https://hub.docker.com/_/golang/
FROM golang:1.13-buster as development

# input parameter (Makefile target)
ARG make_target

RUN mkdir /app 
# copying everything to the container as this is a BUILD ONLY IMAGE
ADD . /app/
WORKDIR /app 

RUN make $make_target

# -- RELEASE STAGE --

FROM golang:1.13-buster

RUN mkdir /app

WORKDIR /app/

# Copy the executable from the previous stage
RUN echo "copy the executable"
COPY --from=development /app/bin/your-go-app .
COPY --from=development /app/config/config.yaml ./config/config.yaml

CMD ["./your-go-app", "-version"]
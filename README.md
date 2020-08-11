# levigo _jadice server_ Docker Container

![jadice server & docker](js_docker.jpeg)

# Table of Contents
1. [Introduction](#introduction)
1. [Requirements](#requirements)
1. [Environment variables](#environment-variables)
1. [Configuration](#configuration)
1. [Logging](#logging)
1. [docker-compose](#docker-compose)

## Introduction
This repository contains a `Dockerfile` for building a docker image containing the levigo [_jadice server_](https://jadice.com/index.php/de/uebersicht-51.html).
It is provided "as is", see [LICENSE.md](https://github.com/levigo/jadice-server-docker/blob/master/LICENSE.md).
The image is based on [openjdk:8u265-jre-buster](https://hub.docker.com/_/openjdk). You can replace it with the JRE distribution of your choice. 

## Requirements
You need version 5.5 or newer of the _jadice server_ distribution to use _jadice server_ in a docker container. For more information on how to get the _jadice server_ distribution visit [jadice.com](https://www.jadice.com).
Also docker-engine 1.12 or newer is required, and for the use of docker-compose.yml version 1.0.8 or newer of docker-compose is required.

## Building the Image
* Copy the _jadice server_ distribution zip into the resources directory.
* Apply customization if needed (see [Configuration](#configuration))
* Run:
```sh
docker build -t=<image-name> .
docker run -p 61616:61616 <image-name>
```
## Environment variables
_jadice server_ evaluates the following environment variables during start.

- `spring.profiles.active` - active features for jadice server (see also `<jadice-server-dir>/server-config/application/active-features.xml`)
- `jadice.server.activemq-host` - set the Apache ActiveMQ broker host (by default _jadice server_ starts its own broker on localhost)



## Configuration
In order to customize the configuration of _jadice server_ you need to copy your existing configuration into the subfolder `customization`. The docker build will copy all files into the directory `<jadice-server-dir>/` inside the container.

## Logging
There are two ways to access the logs from _jadice server_:

- mount an extra volume for log files
- use the docker logging driver

_jadice server_ writes logs by default to `<jadice-server-dir>/logs`. To access the log files, mount some directory from the host and _jadice server_ will write the files in the host's file system.
```sh
docker run -v <host-path>:/opt/jadice-server/logs <images-name>
```
Also the logs are available over the docker logs functionality.

## docker-compose
The `docker-compose.yml` shows an example implementation of the [Compose](https://docs.docker.com/compose/compose-file/) file for _jadice server_.
The docker-compose file defines three services:

- js-amq - a _jadice server_ instance with only the embedded-broker activated
- js-convert - a convert instance of _jadice server_
- js-webservice - the webservice entrypoint

docker-compose.yml uses the [environment variables](#environment-variables) to configure the active features for _jadice server_ instances.
All three services connect together over the js-amq instance. To submit jobs to the _jadice server_ you can either use the webservice interface or the default JMS interface. Both submit jobs to the JMS request queue which is consumed by the js-convert instance.

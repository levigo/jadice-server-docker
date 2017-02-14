FROM openjdk:8u121-jre

MAINTAINER levigo solutions gmbh

ADD resources/jadice-server*.zip /tmp/jadice-server.zip

RUN apt-get update && \
    mkdir /opt/jadice-server && \
    unzip -q /tmp/jadice-server.zip -d /opt/jadice-server/

RUN rm -f /tmp/jadice-server.zip

## copy the config files under customization/ into the jadice-server/ dir
#  existing files will be replaced
##
COPY customization/ /opt/jadice-server/

RUN chmod +x /opt/jadice-server/bin/*.sh

### ensure correct line endings for shell scripts
#
RUN sed -i -e 's/\r$//' /opt/jadice-server/bin/*.sh

ENTRYPOINT /opt/jadice-server/bin/jadice-server.sh

EXPOSE 61616

FROM openjdk:11.0.16-jre-bullseye as build-container

ADD resources/distribution*.zip /tmp/jadice-server.zip

RUN mkdir /opt/jadice-server && \
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


#
# Build resulting image
#
FROM openjdk:11.0.16-jre-bullseye

## un-comment the next two lines to install LibreOffice
#RUN apt-get -qq -y update \
#    && apt-get install -y xvfb libreoffice

COPY --from=build-container /opt/jadice-server /opt/jadice-server

WORKDIR /opt/jadice-server/bin
ENTRYPOINT ["/opt/jadice-server/bin/jadice-server.sh"]

LABEL org.opencontainers.image.description="jadice server" \
      org.opencontainers.image.source="https://github.com/levigo/jadice-server-docker" \
      org.opencontainers.image.vendor="levigo solutions gmbh"

EXPOSE 61616

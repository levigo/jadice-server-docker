FROM openjdk:8u252-jre as build-container

MAINTAINER levigo solutions gmbh

ADD resources/jadice-server*.zip /tmp/jadice-server.zip
 
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
 
FROM openjdk:8u252-jre
COPY --from=build-container /opt/jadice-server /opt/jadice-server
 
ENTRYPOINT /opt/jadice-server/bin/jadice-server.sh
 
EXPOSE 61616
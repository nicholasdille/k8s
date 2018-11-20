FROM ubuntu:xenial

RUN apt-get update \
    && apt-get -y install curl wget jq unzip

ADD shellinaboxd /usr/bin
ADD *.css /usr/share/shellinabox/
ADD entrypoint.sh /
RUN chmod +x /entrypoint.sh

WORKDIR /usr/share/shellinabox
ENTRYPOINT [ "/entrypoint.sh" ]
CMD [ "--disable-ssl", "--service", "/:LOGIN", "--css", "white-on-black.css" ]
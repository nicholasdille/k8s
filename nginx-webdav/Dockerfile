FROM nginx:stable

ARG CI_BUILD_NUMBER

RUN apt-get update \
 && apt-get install -y nginx-extras \
 && rm /etc/nginx/sites-enabled/* \
 && mkdir -p /data \
 && chown www-data /data

COPY default.conf /etc/nginx/conf.d/default.conf

LABEL build=${CI_BUILD_NUMBER}
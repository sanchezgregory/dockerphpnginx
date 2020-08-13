FROM nginx:1.17

MAINTAINER Andreas Schlapbach <schlpbch@gmail.com>

# Make snakeoil certificates available
RUN apt-get update && apt-get install -qy ssl-cert

#Adding NGINX configuration
COPY default.conf /etc/nginx/conf.d/default.conf
COPY nginx.conf /etc/nginx/nginx.conf

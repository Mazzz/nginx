#
# Nginx Dockerfile
#
# https://github.com/dmitryzuev/nginx
#

# Pull base image.
FROM ubuntu:14.04

# Install Nginx.
RUN \
  apt-get install -y curl && \
  echo deb http://nginx.org/packages/ubuntu/ trusty nginx > /etc/apt/sources.list.d/nginx.list && \
  echo deb-src http://nginx.org/packages/ubuntu/ trusty nginx >> /etc/apt/sources.list.d/nginx.list && \
  curl http://nginx.org/keys/nginx_signing.key | apt-key add - && \
  apt-get update && \
  apt-get upgrade -y && \
  apt-get install -y nginx && \
  rm -rf /var/lib/apt/lists/* && \
  chown -R www-data:www-data /usr/share/nginx/html/

# forward request and error logs to docker log collector
RUN \
  ln -sf /dev/stdout /var/log/nginx/access.log && \
  ln -sf /dev/stderr /var/log/nginx/error.log

# Define mountable directories.
VOLUME ["/etc/nginx/sites-enabled", "/etc/nginx/certs", "/etc/nginx/conf.d", "/var/log/nginx", "/usr/share/nginx/html/",  "/var/cache/nginx"]

# Define working directory.
WORKDIR /etc/nginx

# Expose ports.
EXPOSE 80
EXPOSE 443

# Define default command
CMD ["nginx", "-g", "daemon off;"]

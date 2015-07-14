# Use phusion/baseimage as base image. To make your builds
# reproducible, make sure you lock down to a specific version, not
# to `latest`! See
# https://github.com/phusion/baseimage-docker/blob/master/Changelog.md
# for a list of version numbers.
FROM phusion/baseimage:0.9.16

# Use baseimage-docker's init system.
CMD ["/sbin/my_init"]

# Update apt repos
RUN apt-get update

# Install nginx
RUN apt-get install -y nginx-extras curl git wget

# Add our dashboard config to nginx
COPY dashboard.conf /etc/nginx/sites-enabled/dashboard.conf

# Make nginx start up
COPY runit.nginx.sh /etc/service/nginx/run

# Install dependencies for confd
RUN apt-get install -y curl git wget

# Install confd
RUN curl -sqL https://github.com/kelseyhightower/confd/releases/download/v0.9.0/confd-0.9.0-linux-amd64 -o /confd && chmod +x /confd

COPY nginx.toml /etc/confd/conf.d/nginx.toml
COPY dashboard.tmpl /etc/confd/templates/dashboard.tmpl

# Make confd start up
COPY runit.confd.sh /etc/service/confd/run


# Clean up APT when done.
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

ENV ETCD_HOST etcd
ENV ETCD_PORT 4001

EXPOSE 8080

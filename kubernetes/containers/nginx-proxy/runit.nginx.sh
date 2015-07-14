#!/bin/bash 
#exec /usr/sbin/service nginx start
exec /usr/sbin/nginx -c /etc/nginx/nginx.conf  -g "daemon off;"

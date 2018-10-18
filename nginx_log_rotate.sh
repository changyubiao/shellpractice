#!/bin/bash
datedir=`date -d "-1 day" +%F`
[ -d /tmp/nginx_log ] ||  mkdir /tmp/nginx_log
mv /usr/local/nginx/logs/access.log    /tmp/nginx_log/$datedir.log
/etc/init.d/nginx reload  > /dev/null
cd /tmp/nginx_log/
gzip -f $datedir.log

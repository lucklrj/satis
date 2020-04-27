#! /bin/bash
ln -s /usr/local/nginx/sbin/nginx /usr/bin/nginx
cat /app/config/hosts >> /etc/hosts

/usr/bin/supervisord -n -c /etc/supervisord.conf
~

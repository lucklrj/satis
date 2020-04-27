
FROM hub.baidubce.com/tool/nginx-php7.2:with_error_log

MAINTAINER lucklrj <sunny_lrj@yeah.net>

WORKDIR /app

ADD supervisord.conf /etc/supervisord.conf
ADD start.sh /app/
RUN chmod +x /app/start.sh &&  ln -s  /usr/local/php/bin/php /usr/bin/

#timezone
RUN rm -f /etc/localtime && ln -sv /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai" > /etc/timezone

RUN   yum install -y zip unzip git

#RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
#RUN export COMPOSER_PROCESS_TIMEOUT=600

# composer config
RUN composer config -g repo.packagist composer https://packagist.phpcomposer.com
RUN composer config -g process-timeout 6000

# Install satisfy
RUN composer create-project playbloom/satisfy
RUN mkdir -p /app/satisfy/var/cache && chmod 0777 /app/satisfy/var -R

# init nginx
ADD config/nginx/nginx.conf /usr/local/nginx/conf/
ADD config/nginx/satisfy.conf /usr/local/nginx/conf/vhost/

#Start it
ENTRYPOINT ["/app/start.sh"]



FROM hub.baidubce.com/tool/nginx-php7.2:with_error_log

MAINTAINER lucklrj <sunny_lrj@yeah.net>

WORKDIR /app

ADD supervisord.conf /etc/supervisord.conf
ADD start.sh /app/
RUN chmod +x /app/start.sh &&  ln -s  /usr/local/php/bin/php /usr/bin/

#timezone
RUN rm -f /etc/localtime && ln -sv /usr/share/zoneinfo/Asia/Shanghai /etc/localtime && echo "Asia/Shanghai" > /etc/timezone

RUN yum install -y git
# Install satis
RUN composer config -g repo.packagist composer https://mirrors.aliyun.com/composer/
RUN composer create-project composer/satis
RUN composer create-project lucklrj/composer-satis-builder

RUN sed  -e  's/<?php/<?php\nini_set("memory_limit",-1);\n/g'  /app/satis/bin/satis

# Install composer-satis-builder
ADD config/nginx/nginx.conf /usr/local/nginx/conf/
ADD config/nginx/satisfy.conf /usr/local/nginx/conf/vhost/




#Start it
ENTRYPOINT ["/app/start.sh"]


FROM alpine:3.19

RUN apk update && apk add --no-cache \
    nginx \
    php81 php81-fpm php81-mysqli php81-session php81-json \
    wget

RUN mkdir -p /var/www/adminer \
    && mkdir -p /run/nginx

WORKDIR /var/www/adminer

RUN wget https://www.adminer.org/latest.php -O index.php

COPY nginx.conf /etc/nginx/http.d/default.conf
COPY php-fpm.conf /etc/php81/php-fpm.conf

RUN chown -R nobody:nobody /var/www/adminer

RUN echo "session.save_path = /tmp" >> /etc/php81/php.ini

EXPOSE 8080

CMD sh -c "php-fpm81 -D && nginx -g 'daemon off;'"

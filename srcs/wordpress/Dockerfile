FROM alpine:3.19

RUN echo "http://dl-cdn.alpinelinux.org/alpine/v3.19/community" >> /etc/apk/repositories

RUN apk update && apk add --no-cache \
    php81 \
    php81-phar \
    php81-fpm \
    php81-mysqli \
    php81-gd \
    php81-curl \
    php81-xml \
    php81-zip \
    php81-mbstring \
    php81-session \
    php81-json \
    php81-simplexml \
    wget \
    vim \
    php81-redis \
    netcat-openbsd 

RUN mkdir -p /var/www/html

# download WP
RUN wget -q https://wordpress.org/latest.tar.gz \
    && tar -xzf latest.tar.gz \
    && mv wordpress/* /var/www/html/ \
    && rm -rf wordpress latest.tar.gz

# download WP-CLI
RUN wget -q -O /usr/local/bin/wp https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar \
    && chmod +x /usr/local/bin/wp

COPY ./www.conf /etc/php81/php-fpm.d/www.conf
COPY ./init_wp.sh /init_wp.sh
COPY ./test_conn.php /test_conn.php
RUN chmod +x /init_wp.sh

EXPOSE 9000
ENTRYPOINT ["/init_wp.sh"]

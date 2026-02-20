FROM alpine:3.19

RUN apk update && apk add --no-cache mariadb mariadb-client vim 

COPY /init_db.sh /init_db.sh
RUN chmod +x /init_db.sh

EXPOSE 3306

ENTRYPOINT ["/init_db.sh"]
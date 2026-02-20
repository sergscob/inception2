FROM alpine:3.19

RUN apk update && apk add --no-cache redis

RUN mkdir -p /redis-data && chown redis:redis /redis-data

COPY redis.conf /etc/redis/redis.conf

EXPOSE 6379

CMD ["redis-server", "/etc/redis/redis.conf"]

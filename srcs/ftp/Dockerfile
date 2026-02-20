FROM alpine:3.19

RUN apk update && apk add --no-cache vsftpd

COPY vsftpd.conf /etc/vsftpd/vsftpd.conf
COPY entrypoint.sh /entrypoint.sh

RUN chmod +x /entrypoint.sh

EXPOSE 21 30000-30009

CMD ["/entrypoint.sh"]

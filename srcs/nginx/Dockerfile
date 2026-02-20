FROM alpine:3.19

RUN		apk update
RUN		apk add nginx openssl vim

# nginx SSL
RUN mkdir /etc/nginx/ssl
RUN openssl req -newkey rsa:4096 -x509 -sha256 -days 365 -nodes \
       -out /etc/nginx/ssl/sskobyak.crt \
       -keyout /etc/nginx/ssl/sskobyak.key \
       -subj "/C=FR/ST=Paris/L=Paris/O=42 School/OU=sskobyak/CN=sskobyak/"

COPY ./nginx.conf /etc/nginx/http.d/default.conf

# nginx config
RUN mkdir -p /run/nginx

EXPOSE	443

CMD ["nginx", "-g", "daemon off;"]
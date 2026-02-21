FROM alpine:3.19

RUN apk add --no-cache nginx bash curl ca-certificates

RUN mkdir -p /run/nginx /usr/share/nginx/html

COPY ./nginx.conf /etc/nginx/http.d/default.conf

COPY  /src/ /usr/share/nginx/html
RUN  chmod 755 /usr/share/nginx/html -R

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
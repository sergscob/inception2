FROM alpine:3.19

# Устанавливаем Nginx и ca-certificates
RUN apk add --no-cache nginx bash curl ca-certificates

# Создаем папку для Nginx
RUN mkdir -p /run/nginx /usr/share/nginx/html

COPY ./nginx.conf /etc/nginx/http.d/default.conf

COPY  /src/ /usr/share/nginx/html
RUN  chmod 755 /usr/share/nginx/html -R

# Открываем порт
EXPOSE 80

# Запуск nginx
CMD ["nginx", "-g", "daemon off;"]
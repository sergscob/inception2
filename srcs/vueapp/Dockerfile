# --- Stage 1: Build Vue.js ---
FROM alpine:3.19 AS build

# Устанавливаем Node.js и зависимости
RUN apk add --no-cache nodejs npm bash git python3 make g++

WORKDIR /app

# Копируем package.json и устанавливаем зависимости
COPY package*.json ./
RUN npm install

# Копируем исходники
COPY ./src ./src

# Собираем production сборку
RUN npx vue-cli-service build

# --- Stage 2: Nginx для отдачи сайта ---
FROM alpine:3.19

# Устанавливаем Nginx и ca-certificates
RUN apk add --no-cache nginx bash curl ca-certificates

# Создаем папку для Nginx
RUN mkdir -p /run/nginx /usr/share/nginx/html

COPY ./nginx.conf /etc/nginx/http.d/default.conf

# Копируем сборку Vue.js
COPY --from=build /app/dist /usr/share/nginx/html

# Открываем порт
EXPOSE 80

# Запуск nginx
CMD ["nginx", "-g", "daemon off;"]
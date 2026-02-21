# --- Stage 1: Build Vue.js ---
FROM alpine:3.19 AS build


RUN apk add --no-cache nodejs npm bash git python3 make g++

WORKDIR /app

COPY package*.json ./
RUN npm install

COPY ./src ./src

RUN npx vue-cli-service build

# --- Stage 2: Nginx 
FROM alpine:3.19

RUN apk add --no-cache nginx bash curl ca-certificates

RUN mkdir -p /run/nginx /usr/share/nginx/html

COPY ./nginx.conf /etc/nginx/http.d/default.conf

# Copy built Vue.js app from the build stage
COPY --from=build /app/dist /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
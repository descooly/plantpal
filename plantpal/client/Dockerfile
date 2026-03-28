# Stage 1: Build Flutter Web
FROM ghcr.io/cirruslabs/flutter:3.29.0 AS build
WORKDIR /app

COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

COPY lib/ ./lib/
COPY web/ ./web/

RUN flutter build web --release

# Stage 2: Nginx
FROM nginx:alpine

COPY --from=build /app/build/web /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 8080
CMD ["nginx", "-g", "daemon off;"]

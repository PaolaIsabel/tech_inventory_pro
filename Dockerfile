# Etapa 1: compilar la aplicación Flutter Web
##FROM ghcr.io/cirruslabs/flutter:3.44.1 AS build
FROM ghcr.io/cirruslabs/flutter:stable AS build

WORKDIR /app

COPY pubspec.yaml pubspec.lock ./
RUN flutter pub get

COPY . .

RUN flutter build web --release

# Etapa 2: servir la aplicación con Nginx
FROM nginx:alpine

COPY --from=build /app/build/web /usr/share/nginx/html

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
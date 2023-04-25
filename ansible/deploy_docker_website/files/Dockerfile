FROM php:8.2.5-fpm

RUN apt-get update && apt-get install -y curl git zip && rm -rf /var/lib/apt/lists/*

RUN docker-php-ext-install pdo mysqli pdo_mysql sockets

COPY . /app

WORKDIR /app

COPY index.php /app

EXPOSE 80

CMD ["php", "-S", "0.0.0.0:80", "-t", "/app"]

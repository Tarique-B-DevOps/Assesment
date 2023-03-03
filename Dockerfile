# Laravel Backend
FROM php:7.4-fpm


RUN apt-get update && apt-get install -y \
    git \
    unzip \
    libpng-dev \
    libonig-dev \
    libxml2-dev \
    libzip-dev \
    zip \
    curl

RUN apt-get clean && rm -rf /var/lib/apt/lists/*


RUN docker-php-ext-install pdo_mysql mbstring exif pcntl bcmath gd zip


RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


WORKDIR /var/www


COPY . .


RUN composer install --no-dev --optimize-autoloader


RUN php artisan key:generate

EXPOSE 9000

# Vue Frontend
FROM node:16-alpine


WORKDIR /var/www


COPY . /var/www


RUN npm install


RUN npm run build


EXPOSE 8080

# mysql database
FROM mysql:8


ENV MYSQL_DATABASE=laravel_vue_spa \
    MYSQL_USER=root \
    MYSQL_PASSWORD=secret \
    MYSQL_ROOT_PASSWORD=secret

# PHPmyadmin
FROM phpmyadmin/phpmyadmin:latest


ENV PMA_HOST=mysql \
    PMA_USER=root \
    PMA_PASSWORD=secret \
    PMA_ABSOLUTE_URI=http://localhost:8081/phpmyadmin/

EXPOSE 8081
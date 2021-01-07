FROM php:7.4-apache

RUN echo "ServerName localhost" >> /etc/apache2/apache2.conf

RUN apt-get update \
    && apt-get install -y --no-install-recommends apt-utils git libicu-dev g++ libpng-dev libzip-dev;

RUN curl -sSk https://getcomposer.org/installer | php -- --disable-tls && \
    mv composer.phar /usr/local/bin/composer

COPY php.ini /usr/local/etc/php/php.ini
COPY vhosts/app.conf /etc/apache2/sites-enabled/000-default.conf
COPY www/app /var/www/app

ARG APP_ENV=dev

RUN echo ${APP_ENV}

RUN docker-php-ext-install pdo pdo_mysql gd opcache intl zip calendar

RUN addgroup --system symfony --gid 1000 && adduser --system symfony --uid 1000 --ingroup symfony

WORKDIR /var/www/app
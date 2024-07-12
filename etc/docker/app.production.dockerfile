FROM php:8.2.8-fpm-alpine3.17 AS base

# Add base extensions
RUN apk add --no-cache bash jpeg-dev libpng-dev libzip-dev \
    && docker-php-ext-configure gd --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd zip pdo pdo_mysql

# Add composer
COPY --from=composer /usr/bin/composer /usr/bin/composer

RUN apk add -U tzdata
RUN cp /usr/share/zoneinfo/Europe/London /etc/localtime
RUN echo "Europe/London" > /etc/timezone
RUN apk del tzdata

# Set workdir
WORKDIR /src

FROM base AS composer
COPY src /src
RUN composer install --optimize-autoloader --no-dev

FROM node:15 AS node
WORKDIR /src
COPY src /src
RUN npm set progress=false && \
    npm config set depth 0 && \
    npm install && \
    npm run production

FROM base
USER www-data:www-data
COPY etc/php/php.ini /usr/local/etc/php/conf.d/00_php.ini
COPY etc/php-fpm/zz-custom.conf /usr/local/etc/php-fpm.d/zz-custom.conf
COPY --chown=www-data:www-data src /src
COPY --chown=www-data:www-data --from=composer /src/vendor /src/vendor
COPY --chown=www-data:www-data --from=node /src/public/css/app.css /src/public/css/app.css
COPY --chown=www-data:www-data --from=node /src/public/js/app.js /src/public/js/app.js
COPY --chown=www-data:www-data etc/nginx/default.production.conf /etc/nginx/conf.d/default..conf
VOLUME ["/src", "/etc/nginx/conf.d"]
RUN php artisan storage:link && php artisan optimize && php artisan scout:sync-index-settings

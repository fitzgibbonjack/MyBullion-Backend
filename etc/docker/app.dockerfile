FROM php:8.0.7-fpm-alpine3.12

# Add base extensions
RUN apk add --no-cache bash jpeg-dev libpng-dev libzip-dev \
    && docker-php-ext-configure gd --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd zip pdo pdo_mysql

# Add intl
RUN apk add gnu-libiconv icu-dev --update-cache --repository http://dl-cdn.alpinelinux.org/alpine/edge/testing/ --allow-untrusted
RUN docker-php-ext-configure intl && docker-php-ext-install intl
ENV LD_PRELOAD /usr/lib/preloadable_libiconv.so php

RUN apk add -U tzdata
RUN cp /usr/share/zoneinfo/Europe/London /etc/localtime
RUN echo "Europe/London" > /etc/timezone
RUN apk del tzdata

# Add composer
COPY --from=composer /usr/bin/composer /usr/bin/composer
USER www-data
WORKDIR /src

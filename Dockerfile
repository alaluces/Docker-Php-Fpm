FROM php:7.2.10-fpm-stretch

LABEL maintainer="alaluces"

RUN apt-get update && apt-get install -y  \
    libpng-dev \
    libjpeg-dev \
    && docker-php-ext-install -j$(nproc) mysqli \
    && docker-php-ext-install -j$(nproc) bcmath

RUN pecl install redis-4.0.1 \
    && docker-php-ext-enable redis 

RUN docker-php-ext-configure gd --with-jpeg-dir=/usr/include/
RUN docker-php-ext-install -j$(nproc) gd

RUN  mkdir -p /var/www/html 
COPY ./files/src/ /var/www/html/

RUN  rm -rf /usr/local/etc/php-fpm.d/*.conf 
COPY ./files/php/php-fpm.d/www-optimized.conf /usr/local/etc/php-fpm.d/www-optimized.conf
COPY ./files/php/php.ini /usr/local/etc/php/php.ini

ENV TZ=America/Los_Angeles
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

EXPOSE 9000
CMD ["php-fpm"]

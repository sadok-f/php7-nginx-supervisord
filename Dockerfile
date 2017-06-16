FROM php:7.1-fpm

MAINTAINER sadoknet@gmail.com

RUN \
  apt-get -y update && \
  apt-get -y install \
  curl vim wget git build-essential make gcc nasm mlocate apt-transport-https\
  nginx supervisor

RUN wget -O /etc/apt/trusted.gpg.d/php.gpg https://packages.sury.org/php/apt.gpg && \
    echo "deb https://packages.sury.org/php/ jessie main" > /etc/apt/sources.list.d/php.list

#PHP7 dependencies
RUN apt-get update && \
    apt-get install -y --no-install-recommends \
    php7.1-apc \
    php7.1-apcu \
    php7.1-bz2 \
    php7.1-cli \
    php7.1-cgi \
    php7.1-curl \
    php7.1-fpm \
    php7.1-geoip \
    php7.1-gd \
    php7.1-intl \
    php7.1-imagick \
    php7.1-imap \
    php7.1-ldap \
    php7.1-mbstring \
    php7.1-mcrypt \
    php7.1-memcached \
    php7.1-mongo \
    php7.1-odbc \
    php7.1-mysql \
    php7.1-pgsql \
    php7.1-redis \
    php7.1-soap \
    php7.1-sqlite3 \
    php7.1-zip \
    php7.1-xmlrpc \
    php7.1-xsl \
    php7.1-bcmath \
    php7.1-xdebug

COPY resources/etc/ /etc/

#install phpUnit & composer
RUN \
    wget "https://phar.phpunit.de/phpunit.phar" && \
    chmod +x phpunit.phar && \
    mv phpunit.phar /usr/local/bin/phpunit && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


ADD . /var/www
WORKDIR /var/www

RUN usermod -u 1000 www-data


EXPOSE 80

CMD ["/usr/bin/supervisord"]
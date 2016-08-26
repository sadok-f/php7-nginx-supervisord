FROM php:7-fpm

MAINTAINER sadoknet@gmail.com

RUN \
  apt-get -y update && \
  apt-get -y install \
  curl vim wget git build-essential make gcc nasm mlocate \
  nginx supervisor

RUN echo "deb http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list.d/dotdeb.org.list && \
    echo "deb-src http://packages.dotdeb.org jessie all" >> /etc/apt/sources.list.d/dotdeb.org.list && \
    wget -O- http://www.dotdeb.org/dotdeb.gpg | apt-key add -

#PHP7 dependencies
RUN apt-get -y update && \
    apt-get -y install \
    php7.0-mysql php7.0-odbc \
    php7.0-curl php7.0-gd \
    php7.0-intl php-pear \
    php7.0-imap php7.0-mcrypt \
    php7.0-pspell php7.0-recode \
    php7.0-sqlite3 php7.0-tidy \
    php7.0-xmlrpc php7.0-xsl \
    php7.0-xdebug php7.0-redis \
    php-gettext && \
    docker-php-ext-install pdo pdo_mysql opcache

COPY docker/resources/etc/ /etc/

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
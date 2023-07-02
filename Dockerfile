FROM php:7.4.0-apache

EXPOSE 80

ENV DEBIAN_FRONTEND noninteractive
RUN apt update -y && \
	apt install -y curl \
	libpng-dev \
    vim \
    libtidy-dev \
    libzip-dev \
    libexif-dev \
    libbz2-dev \
    libjpeg-dev \
    libjpeg62-turbo-dev \
    libpng-dev \
    libfreetype-dev \
	wget && \
	apt install libmagickwand-dev --no-install-recommends -y && \
	pecl install imagick && docker-php-ext-enable imagick  && \
    apt-get clean && apt-get autoclean && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/www/html/* && \
    a2enmod rewrite && \
    docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg=/usr/local/lib && \
    docker-php-ext-install -j$(nproc) pdo_mysql gd  gettext tidy zip exif bz2 intl

WORKDIR /var/www/html

RUN wget -O /tmp/zenphoto.tar.gz https://github.com/zenphoto/zenphoto/archive/v1.6.tar.gz && \
    /bin/tar xvf /tmp/zenphoto.tar.gz --strip-components=1 && \
    rm /tmp/zenphoto.tar.gz

COPY htaccess .htaccess
RUN chown -R www-data ./ && \
    chmod -R 0600 zp-data && \
    mkdir zp-data/charset_tést

LABEL org.opencontainers.image.version="1.6.0"
LABEL org.opencontainers.image.description="ZenPhoto 1.6.0"
LABEL org.opencontainers.image.url=https://github.com/shaneapowell/docker-zenphoto
LABEL org.opencontainers.image.source=https://github.com/shaneapowell/docker-zenphoto
LABEL org.opencontainers.image.created=2023-02-02T7:30:00-5

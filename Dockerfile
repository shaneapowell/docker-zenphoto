FROM php:8.0.0-apache

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
    libfreetype6-dev \
	wget && \
	apt install libmagickwand-dev --no-install-recommends -y && \
	pecl install imagick && docker-php-ext-enable imagick  && \
    apt-get clean && apt-get autoclean && \
    a2enmod rewrite && \
    docker-php-ext-configure gd --enable-gd --with-freetype --with-jpeg=/usr/local/lib && \
    docker-php-ext-install -j$(nproc) mysqli gd  gettext tidy zip exif bz2 intl && \
    rm -rf /var/lib/apt/lists/* && \
    rm -rf /var/www/html/* && \
    rm -rf /var/cache/apk/*

RUN wget -O /tmp/zenphoto.tar.gz https://github.com/zenphoto/zenphoto/archive/v1.6.tar.gz && \
    /bin/tar xvf /tmp/zenphoto.tar.gz -C /var/www/html --strip-components=1 && \
    rm /tmp/zenphoto.tar.gz

RUN mkdir -p /var/www/data && \
    mv /var/www/html/zp-data /var/www/data && \
    mv /var/www/html/albums /var/www/data && \
    mkdir -p /var/www/data/cache/cache && \
    mkdir -p /var/www/data/cache/cache_html && \
    ln -s /var/www/data/albums /var/www/html/albums && \
    ln -s /var/www/data/zp-data /var/www/html/zp-data && \
    ln -s /var/www/data/cache/cache /var/www/html/cache && \
    ln -s /var/www/data/cache/cache_html /var/www/html/cache_html && \
    chown -R www-data:www-data /var/www

COPY htaccess .htaccess
COPY run.sh /run.sh
RUN chmod a+x /run.sh

LABEL org.opencontainers.image.version="1.6.0"
LABEL org.opencontainers.image.description="ZenPhoto 1.6.0"
LABEL org.opencontainers.image.url=https://github.com/shaneapowell/docker-zenphoto
LABEL org.opencontainers.image.source=https://github.com/shaneapowell/docker-zenphoto
LABEL org.opencontainers.image.created=2023-02-02T7:30:00-5

EXPOSE 80
CMD ["/run.sh"]

#!/bin/sh

mkdir -p /var/www/data/albums
mkdir -p /var/www/data/zp-data
mkdir -p /var/www/data/cache
mkdir -p /var/www/data/cache_html
mkdir -p /var/www/html/zp-data/charset_tést

chown www-data /var/www/data/zp-data
chown www-data /var/www/data/cache
chown www-data /var/www/data/cache_html

/usr/local/bin/apache2-foreground

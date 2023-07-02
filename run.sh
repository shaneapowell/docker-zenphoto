#!/bin/sh

mkdir -p /var/www/html/zp-data/charset_tést
mkdir -p /var/www/data/albums
mkdir -p /var/www/data/cache/cache
mkdir -p /var/www/data/cache/cache_html

chown www-data /var/www/data/zp-data
chown www-data /var/www/data/cache

/usr/local/bin/apache2-foreground

#!/bin/sh

mkdir -p /var/www/data/zp-data/charset_tést
mkdir -p /var/www/data/albums
mkdir -p /var/www/data/cache/cache
mkdir -p /var/www/data/cache/cache_html

echo $ZP_PATH
if [ -n "${ZP_PATH}" ]; then
    echo "Creating sub-path link ${ZP_PATH}"
    ln -s /var/www/html /var/www/html/${ZP_PATH}
fi

chown www-data /var/www/data/zp-data
chown -R www-data /var/www/data/cache

/usr/local/bin/apache2-foreground

#!/bin/sh

chown -R www-data /var/www/html/cache
chown -R www-data /var/www/html/cache_html
chown -R www-data /var/www/html/zp_data
mkdir -p /var/www/html/zp-data/charset_tést

/usr/local/bin/apache2-foreground
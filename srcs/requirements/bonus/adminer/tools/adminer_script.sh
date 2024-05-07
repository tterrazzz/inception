#!/bin/sh

	curl -LO https://github.com/vrana/adminer/releases/download/v4.8.1/adminer-4.8.1.php
	mkdir -p /var/www/html
	mv ./adminer-4.8.1.php /var/www/html/index.php
	adduser -u 82 -D -S -G $ADMINER_USER $ADMINER_USER

	sed -i "s/TO_REPLACE_ADMINER_USER/$ADMINER_USER/g" /etc/php8/php-fpm.d/www.conf
	sed -i "s/TO_REPLACE_ADMINER_PORT/$ADMINER_PORT/g" /etc/php8/php-fpm.d/www.conf

	php-fpm8 --nodaemonize

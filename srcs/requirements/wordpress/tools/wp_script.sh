#!/bin/sh

timeout=9
while ! mysqladmin ping -h "$DB_HOST" --user="$DB_USER" --password="$DB_PWD" --silent ; do
	sleep 1
	timeout=$(($timeout - 1))
	if [ $timeout -eq 0 ]; then
		exit 1
	fi
done

set -x
sed -i "s/TO_REPLACE_WP_PORT/$WP_PORT/g" /etc/php8/php-fpm.d/wp.conf
sed -i "s/TO_REPLACE_WP_WP_USER/$WP_WP_USER/g" /etc/php8/php-fpm.d/wp.conf
sed -i "s/TO_REPLACE_WP_WP_GROUP/$WP_WP_GROUP/g" /etc/php8/php-fpm.d/wp.conf

wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O /tmp/wp-cli.phar
chmod +x /tmp/wp-cli.phar && mv /tmp/wp-cli.phar /usr/local/bin/wp

if [ ! -f /var/www/html/wp-config.php ]; then

	mkdir -p /var/www/html/
	wget -c https://wordpress.org/wordpress-6.4.tar.gz
	tar -xzf wordpress-6.4.tar.gz
	mv wordpress/* /var/www/html/
	rm -rf wordpress wordpress-6.4.tar.gz

	wp config create --allow-root \
		--dbname=$DB_NAME \
		--dbuser=$DB_USER \
		--dbpass=$DB_PWD \
		--dbhost=$DB_HOST \
		--dbcharset="utf8" \
		--dbprefix="wp_" \

	wp core install --allow-root \
		--path='/var/www/html' \
		--url=$WP_URL \
		--title=$WP_TITLE \
		--admin_user=$WP_ADMIN_USER \
		--admin_password=$WP_ADMIN_PWD \
		--admin_email=$WP_ADMIN_EMAIL \
		--skip-email

	wp user create --allow-root \
		--path='/var/www/html/' $WP_USER $WP_USER_EMAIL \
		--user_pass=$WP_USER_PWD \
		--role=contributor


	# BONUS PART
	# Redis
	
	sed -i "62i define ('WP_REDIS_HOST', '$REDIS_HOST');" /var/www/html/wp-config.php
	sed -i "63i define ('WP_REDIS_PORT', '$REDIS_PORT');" /var/www/html/wp-config.php
	sed -i "64i define ('WP_CACHE', true);" /var/www/html/wp-config.php
	sed -i "65i define ('WP_REDIS_CLIENT', 'phpredis');" /var/www/html/wp-config.php
	sed -i "s/define( 'WP_DEBUG', false );/define( 'WP_DEBUG', true );/g" /var/www/html/wp-config.php
	sed -i "66i define ('WP_DEBUG_LOG', true);" /var/www/html/wp-config.php
	sed -i "67i define ('WP_DEBUG_DISPLAY', false);" /var/www/html/wp-config.php
	sed -i "68i define ('FS_METHOD', 'direct');" /var/www/html/wp-config.php

	wp plugin install redis-cache --allow-root --path='/var/www/html/' --activate
	wp plugin update --all --allow-root --path='/var/www/html/'
	wp redis enable --allow-root

	chown -R nginx:nginx /var/www/html/*
	find /var/www/html/ -type d -exec chmod 755 {} \;
	find /var/www/html/ -type f -exec chmod 644 {} \;

fi

php-fpm8 -F -R -y /etc/php8/php-fpm.d/wp.conf

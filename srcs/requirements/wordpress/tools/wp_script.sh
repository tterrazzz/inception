#!/bin/sh

timeout=9
while ! mysqladmin ping -h "$DB_HOST" --user="$DB_USER" --password="$DB_PWD" --silent ; do
	echo "[Info] Waiting to connect Database"
	sleep 1
	timeout=$(($timeout - 1))
	if [ $timeout -eq 0 ]; then
		echo "[Error] Timeout"
		exit 1
	fi
done
echo "[Info] Database connected"

set -x
sed -i "s/TO_REPLACE_WP_PORT/$WP_PORT/g" /etc/php8/php-fpm.d/wp.conf
if [ $? -ne 0 ]; then
	echo "Failed to replace TO_REPLACE_WP_PORT with $WP_PORT"
else
	echo "Replaced TO_REPLACE_WP_PORT with $WP_PORT successfully"
fi

echo "[Info] Installing wp-cli"
wget https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar -O /tmp/wp-cli.phar #> /dev/null 2>&1
chmod +x /tmp/wp-cli.phar && mv /tmp/wp-cli.phar /usr/local/bin/wp
/usr/local/bin/wp --info

if [ ! -f /var/www/html/wp-config.php ]; then

	chown -R nginx:nginx /var/www/html/
	find /var/www/html/ -type d -exec chmod 755 {} \;
	find /var/www/html/ -type f -exec chmod 644 {} \;

	echo "[Info] Installing Wordpress"
	mkdir -p /var/www/html/
	wget -c https://wordpress.org/wordpress-6.4.tar.gz
	tar -xzf wordpress-6.4.tar.gz
	mv wordpress/* /var/www/html/
	rm -rf wordpress wordpress-6.4.tar.gz

	/usr/local/bin/wp config create --allow-root \
		--dbname=$DB_NAME \
		--dbuser=$DB_USER \
		--dbpass=$DB_PWD \
		--dbhost=$DB_HOST \
		--dbcharset="utf8" \
		--dbprefix="wp_" \

	/usr/local/bin/wp core install --allow-root \
		--path='/var/www/html' \
		--url=$WP_URL \
		--title=$WP_TITLE \
		--admin_user=$WP_ADMIN_USER \
		--admin_password=$WP_ADMIN_PWD \
		--admin_email=$WP_ADMIN_EMAIL \
		--skip-email

	/usr/local/bin/wp user create --allow-root \
		--path='/var/www/html/' $WP_USER $WP_USER_EMAIL \
		--user_pass=$WP_USER_PWD \
		--role=contributor

	wp plugin update --all --allow-root --path='/var/www/html/'
	chown -R nginx:nginx /var/www/html/*
	find /var/www/html/ -type d -exec chmod 755 {} \;
	find /var/www/html/ -type f -exec chmod 644 {} \;

	#bonus redis
	
	/usr/local/bin/wp config set --allow-root \
		WP_REDIS_HOST redis \
		WP_REDIS_PORT 6379 --raw \
		WP_CACHE_KEY_SALT $DB_NAME \
		WP_REDIS_CLIENT phpredis

	wp plugin install redis-cache --activate --allow-root
	wp plugin update --all --allow-root
	wp redis enable --allow-root

fi

echo "[Info] Starting php-fpm"
php-fpm8 -F -R -y /etc/php8/php-fpm.d/wp.conf

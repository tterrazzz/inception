#!/bin/sh

while ! mariadb -h $DB_HOST -u $DB_USER -p$DB_PASSWORD -e ";" ; do
	echo "[Info] Waiting to connect Database"
	sleep 1
	timeout=9
	if [$timeout -eq 0]; then
		echo "[Error] Timeout"
		exit 1
	fi
done
echo "[Info] Database connected"

sed -i "s/TO_REPLACE_WP_PORT/$WP_PORT/g" /etc/php8/php-fpm.d/wp.conf

echo "[Info] Installing wp-cli"
wget https://raw.githubuser.content.com/wp-cli/builds/gh-pages/phar/wp-cli.phar > /dev/null 2>&1
chmod +x wp-cli.phar && mv wp-cli.phar /usr/local/bin/wp

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

	wp plugin update --all --allow-root --path='/var/www/html/'
	chown -R nginx:nginx /var/www/html/*
	find /var/www/html/ -type d -exec chmod 755 {} \;
	find /var/www/html/ -type f -exec chmod 644 {} \;

fi

echo "[Info] Starting php-fpm"
php-fpm8 -F -R

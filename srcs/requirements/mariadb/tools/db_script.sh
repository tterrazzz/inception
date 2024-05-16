#!/bin/sh

mkdir -p /var/lib/mysql && chown -R $MYSQL_USER:$MYSQL_USER /var/lib/mysql

sed -i "s/TO_REPLACE_MYSQL_USER/$MYSQL_USER/g" /etc/mysql/my.cnf
sed -i "s/TO_REPLACE_MYSQL_PORT/$DB_PORT/g" /etc/mysql/my.cnf

mysqld_safe &

while ! mysqladmin ping --silent; do
	sleep 1
done

mysql -uroot -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
mysql -uroot -e "CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PWD';"
mysql -uroot -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%' WITH GRANT OPTION;"
mysql -uroot -e "FLUSH PRIVILEGES;"

mysqladmin shutdown

mysqld_safe

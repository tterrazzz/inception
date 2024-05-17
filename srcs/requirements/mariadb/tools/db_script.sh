#!/bin/sh

mkdir -p /var/lib/mysql && chown -R mysql:mysql /var/lib/mysql
chmod -R 755 /var/lib/mysql

#sed -i "s/TO_REPLACE_MYSQL_USER/$MYSQL_USER/g" /etc/mysql/my.cnf
sed -i "s/TO_REPLACE_MYSQL_PORT/$DB_PORT/g" /etc/mysql/my.cnf

mysql_install_db --user=mysql --datadir=/var/lib/mysql

mysqld_safe --datadir=/var/lib/mysql &

while ! mysqladmin ping --silent; do
	sleep 1
done

mysql -u root -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
mysql -u root -e "CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PWD';"
mysql -u root -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%' WITH GRANT OPTION;"
mysql -u root -e "FLUSH PRIVILEGES;"

mysqladmin shutdown

mysqld_safe --datadir=/var/lib/mysql

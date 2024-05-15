#!/bin/sh

whoami

adduser $MYSQL_USER
echo "$MYSQL_USER:$MYSQL_PWD" | chpasswd
addgroup $MYSQL_USER $MYSQL_USER

chown -R $MYSQL_USER:$MYSQL_USER /var/lib/mysql
#chown -R mysql:mysql /var/lib/mysql

sed -i "s/TO_REPLACE_MYSQL_USER/$MYSQL_USER/g" /etc/mysql/my.cnf
sed -i "s/TO_REPLACE_MYSQL_PWD/$MYSQL_PWD/g" /etc/mysql/my.cnf
sed -i "s/TO_REPLACE_MYSQL_PORT/$DB_PORT/g" /etc/mysql/my.cnf

mysql_install_db #--user=mysql

/usr/bin/mysqld_safe &

while ! /usr/bin/mysqladmin ping --silent; do
	sleep 1
done

mysql -u $MYSQL_USER -p $MYSQL_PWD -e "CREATE DATABASE IF NOT EXISTS $DB_NAME;"
mysql -u $MYSQL_USER -p $MYSQL_PWD -e "CREATE USER IF NOT EXISTS '$DB_USER'@'%' IDENTIFIED BY '$DB_PWD';"
mysql -u $MYSQL_USER -p $MYSQL_PWD -e "GRANT ALL PRIVILEGES ON $DB_NAME.* TO '$DB_USER'@'%' WITH GRANT OPTION;"
mysql -u $MYSQL_USER -p $MYSQL_PWD -e "FLUSH PRIVILEGES;"

mysqladmin shutdown

/usr/bin/mysqld_safe

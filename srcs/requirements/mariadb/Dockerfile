FROM	alpine:3.17

RUN	apk update && apk add --no-cache mariadb mariadb-client

COPY	./conf/my.cnf /etc/mysql/my.cnf
COPY	./tools/db_script.sh /tmp/db_script.sh
RUN	chmod +x /tmp/db_script.sh
RUN	mkdir -p /var/log/mysql && touch /var/log/mysql/mysqld.log

EXPOSE	3306

CMD	[ "sh", "/tmp/db_script.sh" ]

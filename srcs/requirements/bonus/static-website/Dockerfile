FROM	alpine:3.19

RUN	apk update && apk upgrade && apk add --no-cache apache2
RUN	mkdir -p /var/www/localhost/htdocs/static

COPY	./html /var/www/localhost/htdocs/static

RUN	echo "ServerName localhost" >> /etc/apache2/httpd.conf

EXPOSE	80

ENTRYPOINT	[ "httpd", "-D", "FOREGROUND" ]


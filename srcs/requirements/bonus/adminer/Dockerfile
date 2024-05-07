FROM	alpine:3.16

RUN	apk update && apk add --no-cache curl \
		less \
		mariadb-client \
		php8 \
		php8-fpm \
		php8-common \
		php8-session \
		php8-iconv \
		php8-json \
		php8-gd \
		php8-curl \
		php8-xml \
		php8-mysqli \
		php8-imap \
		php8-pdo \
		php8-pdo_mysql \
		php8-soap \
		php8-posix \
		php8-gettext \
		php8-ldap \
		php8-ctype \
		php8-dom \
		php8-simplexml
		

COPY	./tools/adminer_script.sh /tmp/adminer_script.sh
COPY	./conf/www.conf /etc/php8/php-fpm.d/www.conf

EXPOSE	9000
STOPSIGNAL	SIGQUIT

ENTRYPOINT	[ "sh", "/tmp/adminer_script.sh" ]

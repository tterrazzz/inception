FROM	alpine:3.16

RUN	apk update && apk upgrade && apk add --no-cache \
		curl \
		wget \
		php8 \
		php8-fpm \
		php8-mysqli \
		php8-phar \
		php8-iconv \
		php8-redis \
		php8-tokenizer \
		mariadb-client

RUN	mkdir -p /var/www/html /run/php /tmp
RUN	adduser -S nginx && addgroup -S nginx
#RUN	docker-php-ext-install ctype

COPY	./conf/wp.conf /etc/php8/php-fpm.d/wp.conf
COPY	./tools/wp_script.sh /tmp/wp_script.sh
RUN	rm /etc/php8/php-fpm.d/www.conf

RUN	chmod +x /tmp/wp_script.sh

EXPOSE	9000

WORKDIR	/var/www/html

ENTRYPOINT	[ "sh", "/tmp/wp_script.sh" ]

FROM	alpine:3.19

RUN	apk update && apk upgrade && apk add --no-cache nginx openssl

RUN	mkdir -p /run/nginx /etc/nginx/ssl /var/www/html /tmp

RUN	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout /etc/nginx/ssl/avan-selfsigned.key \
		-out /etc/nginx/ssl/avan-selfsigned.crt \
		-subj "/C=FR/ST=PACA/L=Nice/O=42/OU=avan/CN=avan.42.fr"

RUN	chmod -R 755 /var/www/html

COPY	./conf/nginx.conf /etc/nginx/nginx.conf
COPY	./tools/nginx_script.sh /tmp/nginx_script.sh

RUN	chmod +x /tmp/nginx_script.sh

CMD [ "sh", "/tmp/nginx_script.sh" ]

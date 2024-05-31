FROM	alpine:3.17

RUN	apk update && apk add --no-cache vsftpd openssl
RUN	mkdir -p /var/log/vsftpd && chown -R root:root /var/log/vsftpd

RUN	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout /etc/ssl/private/vsftpd.pem \
		-out /etc/ssl/certs/vsftpd.pem \
		-subj "/C=FR/ST=PACA/L=Nice/O=42/OU=avan/CN=avan.42.fr"

COPY	./conf/vsftpd.conf /tmp/vsftpd.conf
COPY	./tools/ftp-server_script.sh /tmp/ftp-server_script.sh

EXPOSE	21 21100-21110

ENTRYPOINT	[ "sh", "/tmp/ftp-server_script.sh" ]

FROM	alpine:3.17

RUN	apk update && apk add --no-cache vsftpd openssl

RUN	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout /etc/ssl/private/vsftpd.pem \
		-out /etc/ssl/certs/vsftpd.pem \
		-subj "/C=FR/ST=PACA/L=Nice/O=42/OU=avan/CN=avan.42.fr"

COPY	./conf/vsftpd.chroot_list /tmp/vsftpd.chroot_list
COPY	./conf/vsftpd.conf /tmp/vsftpd.conf
COPY	./tools/ftp-server_script.sh /tmp/ftp-server_script.sh

EXPOSE	21

ENTRYPOINT	[ "sh", "/tmp/ftp-server_script.sh" ]

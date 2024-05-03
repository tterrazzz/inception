FROM	alpine:3.17

RUN	apk update && apk add --no-cache vsftpd

COPY	./tools/ftp-server_script.sh ./tmp/ftp-server_script.sh

EXPOSE	21

ENTRYPOINT	[ "sh", "./tmp/ftp-server_script.sh" ]

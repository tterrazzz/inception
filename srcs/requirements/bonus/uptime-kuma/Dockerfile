FROM	alpine:3.19

RUN	apk update && apk add --no-cache \
			git \
			nodejs \
			npm

RUN	npm install -g npm@9 && npm install -g pm2 && pm2 install pm2-logrotate

COPY	./tools/uptime-kuma_script.sh /tmp/uptime-kuma_script.sh
RUN	chmod 755 /tmp/uptime-kuma_script.sh

WORKDIR	/apps

EXPOSE	3001

ENTRYPOINT	[ "sh", "/tmp/uptime-kuma_script.sh" ]

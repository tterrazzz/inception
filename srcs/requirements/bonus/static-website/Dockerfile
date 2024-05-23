FROM	alpine:3.17

RUN	apk update && apk upgrade && apk add --no-cache nodejs npm openssl
RUN	mkdir -p /apps/certs/ /apps/static

RUN	openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
		-keyout /apps/certs/avan-selfsigned.key \
		-out /apps/certs/avan-selfsigned.pem \
		-subj "/C=FR/ST=PACA/L=Nice/O=42/OU=avan/CN=avan.42.fr"

WORKDIR /apps

COPY	./html /apps/static
COPY	./tools/server.js /apps

EXPOSE	8082

ENTRYPOINT	[ "node", "server.js" ]

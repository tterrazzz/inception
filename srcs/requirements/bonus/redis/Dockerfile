FROM	alpine:3.19

RUN	apk update && apk add --no-cache redis

COPY	./tools/redis_script.sh /tmp/redis_script.sh
RUN	chmod +x /tmp/redis_script.sh

EXPOSE	6379

CMD	[ "sh", "/tmp/redis_script.sh" ]

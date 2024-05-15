#!/bin/sh

if [ ! -d /apps/uptime-kuma/ ]; then

	git clone https://github.com/louislam/uptime-kuma.git
	cd uptime-kuma
	npm run setup
	node server/server.js

else
	cd uptime-kuma
	node server/server.js

fi

#pm2-runtime start server/server.js --name uptime-kuma



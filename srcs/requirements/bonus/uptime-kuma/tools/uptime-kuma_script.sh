#!/bin/sh

git clone https://github.com/louislam/uptime-kuma.git
cd uptime-kuma
npm run setup

pm2-runtime start server/server.js --name uptime-kuma

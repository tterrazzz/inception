
#!/bin/sh

sed -i "s/TO_REPLACE_WP_PORT/$WP_PORT/g" /etc/nginx/nginx.conf
sed -i "s/TO_REPLACE_ADMINER_PORT/$ADMINER_PORT/g" /etc/nginx/nginx.conf
sed -i "s/TO_REPLACE_U-K_PORT/$UK_PORT/g" /etc/nginx/nginx.conf
sed -i "s/TO_REPLACE_STATIC_PORT/$STATIC_PORT/g" /etc/nginx/nginx.conf

nginx -g "daemon off;"

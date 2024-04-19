
#!/bin/sh

sed -i "s/TO_REPLACE_WP_PORT/$WP_PORT/g" /etc/nginx/nginx.conf

nginx -g "daemon off;"

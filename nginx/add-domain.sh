#!/bin/sh

# Check if the required number of arguments are provided
if [ $# -eq 2 ]
then
    # Set the variables from 2 arguments
    domain=$1
    app_local_port=$2
else
    echo "NMS: add-domain usage: $0 domain app_local_port"
    exit 1
fi

# Add the domain and port to the configuration file
echo "
server {
    server_name $domain;
    location / {
        proxy_pass http://host.docker.internal:$app_local_port;
        proxy_http_version 1.1;
        proxy_set_header Upgrade \$http_upgrade;
        proxy_set_header Connection 'upgrade';
        proxy_set_header Host \$host;
        proxy_cache_bypass \$http_upgrade;
        access_log off;
    }
}
" > /etc/nginx/conf.d/$domain-$app_local_port.conf

# Restart Nginx to apply the changes
nginx -s reload

echo "NMS: added $domain:$port to the Nginx!"
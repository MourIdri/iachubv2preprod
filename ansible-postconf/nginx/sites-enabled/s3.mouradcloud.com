server {
 listen 80;

 server_name s3.mouradcloud.com;
 ignore_invalid_headers off;
 client_max_body_size 0;
 proxy_buffering off;
 location / {
   proxy_set_header X-Real-IP $remote_addr;
   proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
   proxy_set_header X-Forwarded-Proto $scheme;
   proxy_set_header Host $http_host;
   #proxy_set_header Host $host;
   proxy_connect_timeout 300;
   proxy_http_version 1.1;
   proxy_set_header Connection "";
   chunked_transfer_encoding off;
   proxy_pass http://s3.corph.mouradcloud.com:9000;
 }

    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/app.mouradcloud.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/app.mouradcloud.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

}

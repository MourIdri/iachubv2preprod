server {
 listen 80;
 server_name www.mouradcloud.com;
 proxy_set_header Forwarded $proxy_protocol_addr;
 proxy_set_header X-Forwarded-For $proxy_protocol_addr; 
 proxy_set_header X-Forwarded-Proto $scheme;




location / {
 proxy_pass http://www.corph.mouradcloud.com;
 #sub_filter_once off;
 #sub_filter 'www.corph.mouradcloud.com' 'www.mouradcloud.com';
 #sub_filter_types *;
 }
 




    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/app.mouradcloud.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/app.mouradcloud.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

}

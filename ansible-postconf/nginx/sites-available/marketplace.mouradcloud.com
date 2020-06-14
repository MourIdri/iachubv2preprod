
		server {
			listen 80;
			server_name marketplace.mouradcloud.com;

			location / {
				proxy_pass http://marketplace.corph.mouradcloud.com;
				proxy_set_header Host $http_host;
				proxy_set_header X-Real-IP $remote_addr;
				proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
				proxy_set_header X-Forwarded-Proto $scheme;


			}
		

    listen 443 ssl; # managed by Certbot
    ssl_certificate /etc/letsencrypt/live/app.mouradcloud.com/fullchain.pem; # managed by Certbot
    ssl_certificate_key /etc/letsencrypt/live/app.mouradcloud.com/privkey.pem; # managed by Certbot
    include /etc/letsencrypt/options-ssl-nginx.conf; # managed by Certbot
    ssl_dhparam /etc/letsencrypt/ssl-dhparams.pem; # managed by Certbot

}


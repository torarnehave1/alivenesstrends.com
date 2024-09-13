server {
    listen 80;
    listen [::]:80;
    server_name alivenesstrends.com www.alivenesstrends.com;

    # Proxy requests to the Node.js application
    location / {
        proxy_pass http://localhost:3002;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Serve static files
    location /static/ {
        alias /var/www/html/alivenesstrends.com/public/static/;
    }

    # Deny access to .htaccess files
    location ~ /\.ht {
        deny all;
    }
}

server {
    server_name {{domains}};
    root "{{project_dir}}/public";

    index index.html index.htm index.php;

    charset utf-8;

    # proxy_set_header X-Forwarded-For $remote_addr;
    # location ~* ^/(api|broadcasting)/ {
    #     try_files $uri $uri/ /index.php?$query_string;
    # }
    # location / {
    #     proxy_pass http://127.0.0.1:3001;
    # }
    
    location / {
        try_files $uri $uri/ /index.php?$query_string;
    }

    location = /favicon.ico { access_log off; log_not_found off; }
    location = /robots.txt  { access_log off; log_not_found off; }

    access_log /var/log/nginx/{{project}}.log;
    error_log /var/log/nginx/{{project}}-error.log error;

    sendfile off;

    client_max_body_size 100m;

    location ~ \.php$ {
        fastcgi_split_path_info ^(.+\.php)(/.+)$;
        fastcgi_pass unix:/var/run/php/php7.4-fpm.sock;
        fastcgi_index index.php;
        include fastcgi_params;
        fastcgi_param SCRIPT_FILENAME $realpath_root$fastcgi_script_name;
        fastcgi_param DOCUMENT_ROOT $realpath_root;

        fastcgi_intercept_errors off;
        fastcgi_buffer_size 16k;
        fastcgi_buffers 4 16k;
        fastcgi_connect_timeout 300;
        fastcgi_send_timeout 300;
        fastcgi_read_timeout 300;
    }

    location ~ /\.ht {
        deny all;
    }

    listen 80; # 443 ssl http2;
    # ssl_certificate {{project_dir}}/fullchain.pem;
    # ssl_certificate_key {{project_dir}}/privkey.pem;
    # ssl_protocols TLSv1.3;
}
#server {
#    listen 80;
#    server_name {{domains}};
#    return 301 https://$host$request_uri;
#}

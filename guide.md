 Nginx Fundamentals (30 min)

Understand server blocks (virtual hosts)
Learn location blocks (URL routing)
Read about listen, root, index directives
See how requests flow through nginx
2. SSL/TLS Setup (15 min)

Why listen 443 ssl is needed
Certificate and key files (ssl_certificate, ssl_certificate_key)
Protocol versions (ssl_protocols)
3. PHP with FastCGI (20 min)

How location ~ \.php$ catches PHP files
What fastcgi_pass does (connects to php-fpm container)
Why you need fastcgi_params and SCRIPT_FILENAME
4. WordPress URL Rewriting (10 min)

try_files $uri $uri/ /index.php$is_args$args; redirects everything to index.php
WordPress handles routing from there
5. Your Docker Implementation (practice)

See how your Dockerfile builds the nginx image
Test locally with the docker-compose setup
Quick start:

Read nginx beginner's guide (5-10 min)
Skim location directive docs
Look at your config and match each line to the docs
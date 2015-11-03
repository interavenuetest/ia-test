install_nginx:
  pkg.installed:
    - names:
      - nginx
      - php5-fpm

nginx_vhost:
  file.managed:
    - name: /etc/nginx/sites-available/default
    - source: salt://container/files/etc/nginx/sites-available/default.tmpl

nginx_service:
  service.running:
    - enable: True
    - name: nginx
    - watch:
      - file: nginx_vhost
      - file: deploy_app
    - require:
      - pkg: install_nginx

deploy_app:
  file.managed:
    - name: /usr/share/nginx/html/index.php
    - source: salt://container/files/usr/share/nginx/html/index.php.tmpl
    - template: jinja

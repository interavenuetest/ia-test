add_haproxy15_ppa:
  pkgrepo.managed:
    - ppa: vbernat/haproxy-1.5

install_haproxy15:
  pkg.installed:
    - name: haproxy
    - require:
      - pkgrepo: add_haproxy15_ppa

drop_the_cert:
  file.managed:
    - name: /etc/haproxy/phpapp.pem
    - source: salt://haproxy/files/etc/haproxy/phpapp.pem.tmpl
    - template: jinja
    - mode: 600

drop_haproxy_conf:
  file.managed:
    - name: /etc/haproxy/haproxy.cfg
    - source: salt://haproxy/files/etc/haproxy/haproxy.cfg.tmpl
    - template: jinja
    - mode: 644

haproxy_service:
  service.running:
    - name: haproxy
    - enable: True
    - restart: True
    - watch:
      - file: drop_the_cert
      - file: drop_haproxy_conf

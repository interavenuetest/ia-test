logstash_forwarder_repo:
  pkgrepo.managed:
    - humanname: logstash-forwarder
    - name: deb http://packages.elastic.co/logstashforwarder/debian stable main
    - dist: stable
    - file: /etc/apt/sources.list.d/logstash-forwarder.list
    - key_url: https://packages.elastic.co/GPG-KEY-elasticsearch

logstash_forwarder_pkg:
  pkg.installed:
    - name: logstash-forwarder

logstash_forwarder_conf:
  file.managed:
    - name: /etc/logstash-forwarder.conf
    - source: salt://elk/files/etc/logstash-forwarder.conf.tmpl
    - template: jinja

logstash_forwarder_crt:
  file.managed:
    - name: /etc/pki/tls/certs/logstash-forwarder.crt
    - source: salt://elk/files/etc/pki/tls/certs/logstash-forwarder.crt.tmpl
    - template: jinja
    - makedirs: True

logstash_forwarder_service:
  service.running:
    - name: logstash-forwarder
    - enable: True
    - restart: True
    - watch:
      - file: logstash_forwarder_conf

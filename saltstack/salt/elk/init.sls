java_repo:
  pkgrepo.managed:
    - ppa: webupd8team/java

oracle_license:
  cmd.run:
    - name: echo oracle-java8-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections && echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | sudo /usr/bin/debconf-set-selections
    - unless: dpkg -l|grep oracle-java8-installer

install_java:
  pkg.installed:
    - name: oracle-java8-installer

elasticsearch_repo:
  pkgrepo.managed:
    - humanname: elastic
    - name: deb http://packages.elastic.co/elasticsearch/2.x/debian stable main
    - dist: stable
    - file: /etc/apt/sources.list.d/elastics.list
    - key_url: https://packages.elastic.co/GPG-KEY-elasticsearch

elasticsearch_package:
  pkg.installed:
    - name: elasticsearch

elasticsearch_service:
  service.running:
    - enable: True
    - name: elasticsearch

download_kibana_tgz:
  archive.extracted:
    - name: /opt/kibana4
    - source: https://download.elastic.co/kibana/kibana/kibana-4.2.0-linux-x64.tar.gz
    - source_hash: md5=51a5c6fc955636b817ec99bf6ec86c90
    - archive_format: tar

symlink_kibana_path:
  file.symlink:
    - name: /opt/kibana
    - target: /opt/kibana4/kibana-4.2.0-linux-x64
    - force: True

kibana_defaults_file:
  file.managed:
    - name: /etc/default/kibana
    - source: salt://elk/files/kibana-4.x-default
    - user: root
    - group: root

kibana_init_script:
  file.managed:
    - name: /etc/init.d/kibana
    - mode: 755
    - source: salt://elk/files/kibana-4.x-init

kibana_service:
  service.running:
    - name: kibana
    - enable: True
    - require:
      - file: kibana_defaults_file
      - file: kibana_init_script
      - archive: download_kibana_tgz

logstash_repo:
  pkgrepo.managed:
    - humanname: logstash
    - name: deb http://packages.elasticsearch.org/logstash/2.0/debian stable main
    - dist: stable
    - file: /etc/apt/sources.list.d/logstash.list
    - key_url: https://packages.elasticsearch.org/GPG-KEY-elasticsearch

logstash_pkg:
  pkg.installed:
    - name: logstash

logstash_nginx_pattern:
  file.managed:
    - name: /opt/logstash/patterns/nginx
    - source: salt://elk/files/opt/logstash/patterns/nginx
    - makedirs: True
    - user: logstash
    - group: logstash

logstash_configs:
  file.recurse:
    - name: /etc/logstash/conf.d
    - source: salt://elk/files/etc/logstash/conf.d/

logstash_forwarder_crt:
  file.managed:
    - name: /etc/pki/tls/certs/logstash-forwarder.crt
    - source: salt://elk/files/etc/pki/tls/certs/logstash-forwarder.crt.tmpl
    - template: jinja
    - makedirs: True

logstash_forwarder_key:
  file.managed:
    - name: /etc/pki/tls/private/logstash-forwarder.key
    - source: salt://elk/files/etc/pki/tls/private/logstash-forwarder.key.tmpl
    - template: jinja
    - makedirs: True

logstash_service:
  service.running:
    - restart: True
    - enable: True
    - name: logstash
    - watch:
      - file: logstash_nginx_pattern
      - file: logstash_configs
      - file: logstash_forwarder_crt
      - file: logstash_forwarder_key

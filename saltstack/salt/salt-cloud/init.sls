cloud_provider_conf:
  file.managed:
    - name: /etc/salt/cloud.providers.d/lxc.conf
    - source: salt://salt-cloud/files/etc/salt/cloud.providers.d/lxc.conf

cloud_profiles_conf:
  file.recurse:
    - name: /etc/salt/cloud.profiles.d
    - source: salt://salt-cloud/files/etc/salt/cloud.profiles.d

ia_map_conf:
  file.managed:
    - name: /etc/salt/cloud.maps.d/ia.map
    - source: salt://salt-cloud/files/etc/salt/cloud.maps.d/ia.map

salt_cloud_provision_elk:
  cloud.profile:
    - profile: elk-lxc
    - name: elk
    - ip: 10.0.3.31

{% for container in 'nginx1', 'nginx2' %}
salt_cloud_provision_{{ container }}:
  cloud.profile:
    - profile: standard-lxc
    - name: {{ container }}
{% endfor %}

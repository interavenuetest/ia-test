common_packages:
  pkg.installed:
    - names:
      - git
      - vim
      - virt-what
      - python-pip
      - python2.7
      - python2.7-dev
      - software-properties-common
      - python-software-properties
      - lxc
      - python-ipy
      - python-requests

{% for directory in 'cloud.profiles.d', 'cloud.providers.d', 'cloud.maps.d', 'cloud.deploy.d' %}
salt_cloud_dirs_{{ directory }}:
  file.directory:
    - name: /etc/salt/{{ directory }}
    - user: root
    - group: root
    - dir_mode: 755
{% endfor %}

lxc_bootstrap:
  cmd.run:
    - name: lxc-checkconfig >> /root/lxc-checkconfig.log
    - shell: /bin/bash
    - creates: /root/lxc-checkconfig.log

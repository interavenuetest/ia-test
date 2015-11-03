base:
  '*-vagrant':
    - packages
    - salt-vim
    - salt-cloud
    - haproxy

  'nginx*':
    - container
    - elk.forwarder

  'elk*':
    - elk

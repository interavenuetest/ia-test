clone_salt_plugins:
  git.latest:
    - user: root
    - name: https://github.com/saltstack/salt-vim.git
    - rev: master
    - target: /root/.vim
    - force: True
    - require:
      - sls: packages

append_dot_vimrc:
  file.append:
    - name: /root/.vimrc
    - text:
      - set nocompatible
      - filetype plugin indent on
    - require:
      - git: clone_salt_plugins

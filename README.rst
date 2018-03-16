Install from scratch
====================


Install
=======

Local::

    DOTFILES_PATH=~/new_dotfiles home/bin/dotfiles-playbook install

Remote::

    DOTFILES_PATH=~/new_dotfiles home/bin/dotfiles-playbook install user@host

Create your user
================

Local::

    DOTFILES_PATH=~/new_dotfiles home/bin/dotfiles-playbook user --sudo

Remote::

    DOTFILES_PATH=~/new_dotfiles home/bin/dotfiles-playbook user user@host --sudo


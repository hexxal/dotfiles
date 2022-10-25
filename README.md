# Ansible dotfiles configuration (Ubuntu server 22.04 LTS)

- Install git
  - `sudo apt install git`
- Install ansible
  - `sudo apt install ansible`
- Install ansible playbook(s)
  - `ansible-playbook -i hosts -K playbook-cli.yml`
  - `ansible-playbook -i hosts -K playbook-gui.yml`

# CLI

- network-manager
- zsh
- fzf
- rxvt-unicode
- bluetooth
- pavucontrol
- pulseaudio
- pulseaudio-module-bluetooth

# GUI

- i3
- xinit
- x11-xserver-utils
- snapd
- firefox
- fonts-inconsolata
- arandr
- nemo

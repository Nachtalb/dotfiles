# Nachtalbs Dotfiles

Create default home structure and symlinks by running `link_home.py` with Python3.

Install:
```
curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
curl -L https://get.oh-my.fish | fish
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt-get install -y nodejs

find ~/.gnupg -type d -exec chmod 700 {} \;
find ~/.gnupg -type f -exec chmod 600 {} \;
chmod 600 ~/.ssh/id_rsa
```

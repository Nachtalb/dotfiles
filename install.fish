#!/usr/bin/fish
mkdir -p ~/.ssh
mkdir -p ~/.gnupg
mkdir -p ~/bin
mkdir -p ~/src/github.com

ln -s ~/.config/fish/_symlinks/gpg.pub ~/.gnupg/gpg.pub
ln -s ~/.config/fish/_symlinks/id_rsa.pub ~/.ssh/id_rsa.pub
ln -s ~/.config/fish/_symlinks/.gitconfig ~/.gitconfig
ln -s ~/.config/fish/_symlinks/.global_gitignore ~/.global_gitignore
ln -s ~/.config/fish/_symlinks/.pdbrc ~/.pdbrc
ln -s ~/.config/fish/_symlinks/.pythonrc ~/.pythonrc
ln -s ~/.config/fish/_symlinks/.tmux.conf ~/.tmux.conf

chmod 0600 ~/.ssh/id_rsa
chmod 0600 ~/.gnupg/gpg.gpg

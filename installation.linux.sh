#!/usr/bin/env sh
BOLD="\e[1m"
MAGENTA="\e[95m"
NORMAL="\e[39m"

run () {
	>&2 echo $BOLD$MAGENTA"-> $*"$NORMAL
	# $*
}

run wget -qO - https://adoptopenjdk.jfrog.io/adoptopenjdk/api/gpg/key/public | sudo apt-key add -
run sudo add-apt-repository --yes https://adoptopenjdk.jfrog.io/adoptopenjdk/deb/
run sudo apt-get install -y software-properties-common
run sudo add-apt-repository ppa:jonathonf/vim

run sudo apt install -y fish tmux git vim \
	direnv \
	nodejs \
	adoptopenjdk-11-hotspot \
	\
	libpq-dev zlib1g-dev libssl-dev libncurses5-dev libbz2-dev liblzma-dev libsqlite3-dev \
	tcl-dev libgdbm-dev libreadline-dev tk tk-dev libgdbm-dev libexpat1-dev libexpat1-dev \
	libffi-dev uuid-dev libpython-dev python-dev software-properties-common build-essential \
	libxml2-dev libxslt-dev libjpeg-dev python3


run curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.35.3/install.sh | bash  		# Install NVM
run curl -L https://github.com/pyenv/pyenv-installer/raw/master/bin/pyenv-installer | bash  	# Install Pyenv
run git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm				# Install Tmux Plugin Manager
run curl -L https://get.oh-my.fish | fish								# Install Oh my fish
run # Configure OMF
run rm -rf ~/.vim ~/.vim_runtime ~/.vimrc
run mkdir -p ~/.config/omf
run cd ~/.config/omf
run ln -sf bunlde.linux bundle
run rm -rf *
run git clone https://github.com/Nachtalb/dotfiles.git .
run python3 init_home.py

run cd ~/.vim
run ln -fs ~/.vim/plugged/vim-plug/plug.vim autoload/plug.vim
run git submodule init
run git submodule update
run fish -c "omf instal"

run find ~/.gnupg -type d -exec chmod 700 {} \;
run find ~/.gnupg -type f -exec chmod 600 {} \;
run chmod 600 ~/.ssh/id_rsa

echo $BOLD$MAGENTA"Please open vim and run \"CocInstall coc-json coc-python coc-cmake coc-css coc-cssmodules coc-git coc-html coc-highlight coc-markdownlint coc-sh coc-sql coc-svg coc-translator coc-xml coc-yaml\""$NORMAL

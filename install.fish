#!/usr/bin/fish
set_color green && echo "Add default directories" && set_color white
mkdir -p ~/.ssh
mkdir -p ~/.gnupg
mkdir -p ~/bin
mkdir -p ~/src/github.com

set_color green && echo "Link dotfiles" && set_color white
ln -s ~/.config/fish/_symlinks/gpg.pub ~/.gnupg/gpg.pub
ln -s ~/.config/fish/_symlinks/id_rsa.pub ~/.ssh/id_rsa.pub
ln -s ~/.config/fish/_symlinks/.gitconfig ~/.gitconfig
ln -s ~/.config/fish/_symlinks/.global_gitignore ~/.global_gitignore
ln -s ~/.config/fish/_symlinks/.pdbrc ~/.pdbrc
ln -s ~/.config/fish/_symlinks/.pythonrc ~/.pythonrc
ln -s ~/.config/fish/_symlinks/.tmux.conf ~/.tmux.conf

set_color green && echo "Fix dotfile premissions" && set_color white
chmod 0600 ~/.ssh/id_rsa
chmod 0600 ~/.gnupg/gpg.gpg

if command -q pyenv
    if not pyenv versions | grep -q nvim
        set_color green && echo "Setting up python" && set_color white
        cd ~/.vim
        pyenv virtualenv (pyenv versions --skip-aliases --bare | rg '^3[0-9.]+$' | sort -Vr | head -n 1) nvim
        pyenv activate nvim
        pip install -U pip setuptools black autopep8 flake8 yapf pylint
    else
        pyenv activate nvim
        pip install -U pip setuptools black autopep8 flake8 yapf pylint
    end
    ln -sf (pyenv which black) ~/.config/fish/bin/
    ln -sf (pyenv which yapf) ~/.config/fish/bin/
    ln -sf (pyenv which autopep8) ~/.config/fish/bin/
    ln -sf (pyenv which flake8) ~/.config/fish/bin/
    ln -sf (pyenv which pylint) ~/.config/fish/bin/
    pyenv deactivate
else
    set_color red && printf "Pyenv not installed, run: " && set_color grey && echo "curl https://pyenv.run | sh" && set_color white
end

set_color green && echo "DONE!" && set_color white

#!/usr/bin/fish
set_color green && echo "Add default directories" && set_color white
run mkdir -p ~/.ssh
run mkdir -p ~/.gnupg
run mkdir -p ~/bin
run mkdir -p ~/src/github.com

set_color green && echo "Link dotfiles" && set_color white
run ln -s ~/.config/fish/_symlinks/public.gpg ~/.gnupg/public.gpg
run ln -s ~/.config/fish/_symlinks/id_rsa.pub ~/.ssh/id_rsa.pub
run ln -s ~/.config/fish/_symlinks/.gitconfig ~/.gitconfig
run ln -s ~/.config/fish/_symlinks/.global_gitignore ~/.global_gitignore
run ln -s ~/.config/fish/_symlinks/.pdbrc ~/.pdbrc
run ln -s ~/.config/fish/_symlinks/.pythonrc ~/.pythonrc
run ln -s ~/.config/fish/_symlinks/.tmux.conf ~/.tmux.conf

set_color green && echo "Fix dotfile premissions" && set_color white
run chmod 0600 ~/.ssh/id_rsa
run chmod 0600 ~/.gnupg/gpg.gpg

if command -q pyenv
    set_color green && echo "Setting up python scripts" && set_color white
    if not pyenv versions | grep -q nvim
        run pyenv virtualenv (pyenv versions --skip-aliases --bare | rg '^3[0-9.]+$' | sort -Vr | head -n 1) nvim
        run pyenv activate nvim
        run pip install -U pip setuptools black autopep8 flake8 yapf pylint
    else
        run pyenv activate nvim
        run pip install -U pip setuptools black autopep8 flake8 yapf pylint
    end
    run ln -sf (pyenv which yapf) ~/.config/fish/bin/
    run ln -sf (pyenv which autopep8) ~/.config/fish/bin/
    run ln -sf (pyenv which flake8) ~/.config/fish/bin/
    run ln -sf (pyenv which pylint) ~/.config/fish/bin/
    run pyenv deactivate
    run ln -sf (pyenv which black) ~/.config/fish/bin/
else
    set_color red && printf "Pyenv not installed, run: " && set_color grey && echo "curl https://pyenv.run | sh" && set_color white
end

set_color green && echo "DONE!" && set_color white

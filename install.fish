#!/usr/bin/fish

function title
    set_color green && echo $argv && set_color white
end

if grep -q 'arch' < /etc/os-release
    title "Install packages"
    run sudo pacman -Su
    run sudo pacman -Sy --needed nodejs npm yarn git-delta ripgrep go exa btop bat
end

title "Add default directories"
run mkdir -p ~/.ssh
run mkdir -p ~/.gnupg
run mkdir -p ~/bin
run mkdir -p ~/src/github.com

title "Link dotfiles"
run ln -s ~/.config/fish/_symlinks/public.gpg ~/.gnupg/public.gpg
run ln -s ~/.config/fish/_symlinks/id_ed25519.pub ~/.ssh/id_ed25519.pub
run ln -s ~/.config/fish/_symlinks/.gitconfig ~/.gitconfig
run ln -s ~/.config/fish/_symlinks/.global_gitignore ~/.global_gitignore
run ln -s ~/.config/fish/_symlinks/.pdbrc ~/.pdbrc
run ln -s ~/.config/fish/_symlinks/.pythonrc ~/.pythonrc
run ln -s ~/.config/fish/_symlinks/.tmux.conf ~/.tmux.conf

title "Fix dotfile premissions"
run chmod 0600 ~/.ssh/id_rsa
run chmod 0600 ~/.gnupg/gpg.gpg

if not command -q pyenv
    title "Install pyenv"
    run curl https://pyenv.run/ | sh
end

if command -q pyenv
    title "Setting up python scripts"
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

if test -f ~/.gnupg/private.gpg
    title "Import GPG key"
    run gpg --import ~/.gnupg/private.gpg
end

title "Install / Update fisher packages"
fisher update

title "DONE!"

#!/usr/bin/fish

function title
    set_color green && echo $argv && set_color white
end

if grep -q 'arch' < /etc/os-release
    title "Install packages"
    run sudo pacman -Su
    run sudo pacman -Sy --needed nodejs npm yarn git-delta ripgrep go exa btop bat
end

if not command -q starship
    title "Install starship"
    run curl -sS https://starship.rs/install.sh | sh
end

title "Add default directories"
run mkdir -p ~/bin
run mkdir -p ~/src/github.com

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
    else
        run pyenv activate nvim
    end
    run pip install -U pip setuptools black autopep8 flake8 yapf pylint mypy
    run ln -sf (pyenv which yapf) ~/.config/fish/bin/
    run ln -sf (pyenv which autopep8) ~/.config/fish/bin/
    run ln -sf (pyenv which flake8) ~/.config/fish/bin/
    run ln -sf (pyenv which pylint) ~/.config/fish/bin/
    run ln -sf (pyenv which mypy) ~/.config/fish/bin/
    run ln -sf (pyenv which black) ~/.config/fish/bin/
    run pyenv deactivate
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

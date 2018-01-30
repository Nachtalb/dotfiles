# # # # # # # # # # # # # # # #
#    Abbreviations Config     #
# # # # # # # # # # # # # # # #

abbr open='xdg-open'

# Buildout
abbr pin='bin/instance'
abbr pbo='bin/buildout'
# Instance
abbr pinf='bin/instance fg'

# Oh my fish
abbr omr='omf reload'

# Basic Builtin
abbr la='ls -lAhX --color'
abbr lt='ls -lAht --color'
abbr ls='ls -GhX --color'
abbr ll='ls -lX --color'
abbr grep='grep --color'
abbr rmf='rm -rf'
abbr rtws='sed -i \'s/[[:space:]]*\$//\''

# Aptitude
abbr aup='sudo apt update && sudo apt list --upgradable -a && sudo apt dist-upgrade && sudo apt autoclean && sudo apt autoremove'
abbr update='sudo apt update'
abbr upgrade='sudo apt upgrade'

# GIT
# rebase
abbr grc='git rebase --continue'
abbr gri='git rebase -S -i'
abbr gra='git rebase --abort'
# commit
abbr gaa='git add .'
abbr gca='git commit -S --all --amend --no-edit'
abbr gc='git commit -S -m'
# push
abbr gpf='git push --sign=if-asked --force'
abbr gp='git push --sign=if-asked'
# stashing
abbr gsa='git stash save'
abbr gsp='git stash drop    '
abbr gsd='git stash delete'
# misc
abbr glog='git log --graph'
abbr gl1="git log --graph --abbrev-commit --decorate --format='%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"
abbr gl2="git log --graph --abbrev-commit --decorate --format='%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all"
abbr gcp='git cherry-pick -S '
abbr gco='git checkout'
abbr gst='git status'
abbr gpu='git pull'

# Misc
abbr fsize='du -sh' # Show dictionary size

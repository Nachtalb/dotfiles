# # # # # # # # # # # # # # # #
#    Abbreviations Config     #
# # # # # # # # # # # # # # # #

abbr ap 'sudo apt update'
abbr aup 'sudo apt upgrade'

# Oh my fish
abbr omr 'omf reload'

# Basic Builtin
abbr ls 'ls -hCv'
alias la 'ls -ClAphv'
abbr ll 'la'
abbr lt 'ls -ClAtph'
abbr rmf 'rm -rf'

# GIT
# rebase
abbr grc 'git rebase --continue'
abbr gri 'git rebase -r -S -i'
abbr gra 'git rebase --abort'
# commit
abbr gaa 'git add .'
abbr gca 'git commit -S --amend --no-edit'
abbr gcaa 'git commit -S --all --amend --no-edit'
abbr gc 'git commit -S -m'
# git fetch
abbr gfa 'git fetch --all -p'
abbr gba 'env GIT_PAGER=cat git branch --all'
abbr gbd 'git branch -D'
# pull
abbr gpl 'git pull -r'
# reset
abbr grh 'git reset --hard'
# push
abbr gpf 'git push --force'
abbr gp 'git push'
# stashing
abbr gsa 'git stash save'
abbr gsp 'git stash pop'
abbr gsd 'git stash drop'
# misc
abbr glog 'git log --graph'
abbr gl1 "env GIT_PAGER=less git log --graph --abbrev-commit --decorate --format='%C(bold blue)%h%C(reset) - %C(bold green)(%ai)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --color=always --all"
abbr gl2 "env GIT_PAGER=less git log --graph --abbrev-commit --decorate --format='%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ai)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --color=always --all "
abbr gcp 'git cherry-pick -S '
abbr gco 'git checkout'
abbr gcb 'git checkout -b '
abbr gst 'git status'
abbr gdf 'git diff'
abbr gdfn 'git diff --name-status'
abbr gds 'git diff --staged'
abbr gdsn 'git diff --staged --name-status'
abbr gr 'git remote'
abbr grv 'git remote -v'
abbr gup 'git pull -r && git fetch -p origin && remove-merged-git-branches && git remote | grep -v origin | xargs -L1 git fetch -p'

# Misc
abbr ppy 'pyenv virtualenv (pyenv versions --skip-aliases --bare | rg \'^[0-9.]+$\' | sort -Vr | head -n 1) (basename  (pwd)) && pyenv local (basename  (pwd)) && pip install -U pip setuptools'
abbr :q exit

# SSH shortcuts
abbr d1 'mosh d1'
abbr pi 'mosh pi'

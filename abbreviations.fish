###############################
#    Abbreviations Config     #
###############################

# Buildout
abbr pin 'bin/instance'
abbr pbo 'bin/buildout'
# Instance
abbr pinf 'bin/instance fg'
# Misc
abbr psi 'bin/solr-instance'
abbr pt 'bin/test'
abbr prs 'python bootstrap.py && bin/buildout'
abbr psf 'bin/solr-instance start && bin/tika-server start 2> /dev/null & && bin/instance fg'
abbr psm 'bin/solr-instance start && bin/tika-server start 2> /dev/null &'

# Oh my fish
abbr omr 'omf reload'

# Basic Builtin
abbr ls 'ls -hC'
abbr la 'ls -ClAph'
abbr lt 'ls -ClAtph'
abbr ll 'la'
abbr rmf 'rm -rf'

# Apt
abbr anstall 'sudo apt install '
abbr apdate 'sudo apt update'
abbd apgrade 'sudo apt upgrade'

# GIT
# rebase
abbr grc 'git rebase --continue'
abbr gri 'git rebase -S -i'
abbr gra 'git rebase --abort'
# commit
abbr gaa 'git add .'
abbr gca 'git commit -S --amend --no-edit'
abbr gcaa 'git commit -S --all --amend --no-edit'
abbr gc 'git commit -S -m'
# git fetch
abbr gfa 'git fetch --all'
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
abbr gl1 "git log --graph --abbrev-commit --decorate --format='%C(bold blue)%h%C(reset) - %C(bold green)(%ai)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"
abbr gl2 "git log --graph --abbrev-commit --decorate --format='%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ai)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all"
abbr gcp 'git cherry-pick -S '
abbr gco 'git checkout'
abbr gcb 'git checkout -b ne/'
abbr gst 'git status'
abbr gdf 'git diff'
abbr gdfn 'git diff --name-status'
abbr gds 'git diff --staged'
abbr gdsn 'git diff --staged --name-status'
abbr go 'git open'
abbr gr 'git remote'
abbr grv 'git remote -v'

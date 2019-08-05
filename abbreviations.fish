# # # # # # # # # # # # # # # #
#    Abbreviations Config     #
# # # # # # # # # # # # # # # #

abbr gtemp 'cd /Users/bernd/Development/temp && rm test && echo 1 || touch test && git add . && git commit -S -m test && cd -'

# Buildout
abbr pin 'bin/instance'
abbr pbo 'bin/buildout && notify Finished Buildout || notify Failed Buildout'
abbr pbn 'bin/buildout -N && notify Finished Buildout || notify Failed Buildout'
# Instance
abbr pinf 'bin/instance fg'
# Misc
abbr psi 'bin/solr-instance'
abbr pt 'bin/test && notify Finished Tests || notify Failed Tests'
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
abbr rtws 'sed -i \'s/[[:space:]]*\$//\''
alias fmb 'sudo fakemail --path "~/Development/fakemail/" --background --port 25 --log "~/Development/fakemail/fakemail.log"'
alias fm 'sudo fakemail --path "~/Development/fakemail/" --port 25 --log "~/Development/fakemail/fakemail.log"'

# Applications
abbr preview='/Applications/Preview.app/Contents/MacOS/Preview'

# Brew
abbr bup 'brew update && brew upgrade && brew cleanup && brew cask cleanup'

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
abbr gl1 "env GIT_PAGER=less git log --graph --abbrev-commit --decorate --format='%C(bold blue)%h%C(reset) - %C(bold green)(%ai)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --color=always --all"
abbr gl2 "env GIT_PAGER=less git log --graph --abbrev-commit --decorate --format='%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ai)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --color=always --all "
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

# Misc
abbr fsize 'du -sh' # Show dictionary size
abbr ccat '~/.pyenv/versions/2.7.14/bin/pygmentize -g -O style=colorful,linenos=1'  # Check path in a new installtion
abbr ppy 'pyenv virtualenv 3.7.2 (basename  (pwd)) && pyenv local (basename  (pwd)) && pip install -U pip'
abbr :q exit

# SSH shortcuts
abbr vps 'ssh vps'
abbr plex 'ssh plex'
abbr own 'ssh own'
abbr own2 'ssh own2'

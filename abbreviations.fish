# # # # # # # # # # # # # # # #
#    Abbreviations Config     #
# # # # # # # # # # # # # # # #

# Buildout
abbr pin 'bin/instance'
abbr pbo 'bin/buildout'
# Instance
abbr pinf 'bin/instance fg'
# Misc
abbr psi 'bin/solr-instance'
abbr pt 'bin/test'
abbr plone-setup 'pyenv local plone-env; printf "[buildout]\nextends =\n    development.cfg\n\n[omelette]\nrecipe =\n\n" > development_nick.cfg; ln -fs development_nick.cfg buildout.cfg; python bootstrap.py; bin/buildout;'
abbr plone-resetup 'python bootstrap.py; bin/buildout'
abbr plone-start 'bin/solr-instance start; bin/tika-server start 2> /dev/null &; bin/instance fg'

# Oh my fish
abbr omr 'omf reload'

# Basic Builtin
abbr ls 'ls -hC'
abbr la 'ls -ClAph'
abbr lt 'ls -ClAtph'
abbr ll 'la'
abbr grep 'grep --color'
abbr rmf 'rm -rf'
abbr rtws 'sed -i \'s/[[:space:]]*\$//\''
alias fmb 'sudo python /Users/bernd/.config/omf/scripts/fakemail.py --path "/Users/bernd/Development/fakemail/" --background --open --port 25 --log "/Users/bernd/Development/fakemail/fakemail.log"'
alias fm 'sudo python /Users/bernd/.config/omf/scripts/fakemail.py --path "/Users/bernd/Development/fakemail/" --open --port 25 --log "/Users/bernd/Development/fakemail/fakemail.log"'

# Applications
abbr preview='/Applications/Preview.app/Contents/MacOS/Preview'

# Brew 
abbr bup 'brew update; brew upgrade; brew cleanup; brew cask cleanup'

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
abbr gpl 'git pull'
# reset
abbr grh 'git reset --hard'
# push
abbr gpf 'git push --sign=if-asked --force'
abbr gp 'git push --sign=if-asked'
# stashing
abbr gsa 'git stash save'
abbr gsp 'git stash pop'
abbr gsd 'git stash drop'
# misc
abbr glog 'git log --graph'
abbr gl1 "git log --graph --abbrev-commit --decorate --format='%C(bold blue)%h%C(reset) - %C(bold green)(%ar)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --all"
abbr gl2 "git log --graph --abbrev-commit --decorate --format='%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ar)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --all"
abbr gcp 'git cherry-pick -S '
abbr gco 'git checkout'
abbr gcb 'git checkout -b ne/'
abbr gst 'git status'
abbr gpu 'git pull'
abbr gdf 'git diff'
abbr gdfn 'git diff --name-status'
abbr gds 'git diff --staged'
abbr gdsn 'git diff --staged --name-status'

# Misc
abbr fsize 'du -sh' # Show dictionary size
abbr ccat '/Users/bernd/.pyenv/versions/2.7.14/bin/pygmentize -g -O style=colorful,linenos=1'  # Check path in a new installtion

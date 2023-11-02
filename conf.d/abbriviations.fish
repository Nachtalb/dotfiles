status is-interactive || exit
abbr rmf 'rm -rf'

# git rebase
abbr grc 'git rebase --continue'
abbr gri 'git rebase -r -i'
abbr gra 'git rebase --abort'
abbr grs 'git rebase --skip'
# git cherry pick
abbr gcp 'git cherry-pick'
abbr gcps 'git cherry-pick --abort'
abbr gcpc 'git cherry-pick --continue'
# git merge
abbr gm 'git merge'
abbr gma 'git merge --abort'
abbr gmc 'git merge --continue'
# git commit
abbr ga 'git add'
abbr gaa 'git add .'
abbr gca 'git commit --amend --no-edit'
abbr gcaa 'git commit --all --amend --no-edit'
abbr gc 'git commit -m'
# git fetch
abbr gfa 'git fetch --all -p'
abbr gba 'env GIT_PAGER=cat git branch --all'
abbr gbd 'git branch -D'
abbr gbm 'git branch -m'
# git pull
abbr gpl 'git pull -r'
# git reset
abbr grh 'git reset --hard'
abbr grs 'git reset --soft'
# git push
abbr gpf 'git push --force'
abbr gp 'git push'
# git stash
abbr gsa 'git stash save'
abbr gsp 'git stash pop'
abbr gsd 'git stash drop'
abbr gsl 'git stash list'
abbr gss 'git stash show'
# git log
abbr glog 'git log --graph'
abbr gl1 "git log --graph --abbrev-commit --decorate --format='%C(bold blue)%h%C(reset) - %C(bold green)(%ai)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --color=always --all"
abbr gl2 "git log --graph --abbrev-commit --decorate --format='%C(bold blue)%h%C(reset) - %C(bold cyan)%aD%C(reset) %C(bold green)(%ai)%C(reset)%C(bold yellow)%d%C(reset)%n''          %C(white)%s%C(reset) %C(dim white)- %an%C(reset)' --color=always --all "
abbr glw "watch -n 3 --color \"git log --graph --abbrev-commit --decorate --format='%C(bold blue)%h%C(reset) - %C(bold green)(%ai)%C(reset) %C(white)%s%C(reset) %C(dim white)- %an%C(reset)%C(bold yellow)%d%C(reset)' --color=always --all\""
# git checkout
abbr gco 'git checkout'
abbr gcb 'git checkout -b'
# git diff
abbr gst 'git status'
abbr gdf 'git diff'
abbr gdfn 'git diff --name-status'
abbr gds 'git diff --staged'
abbr gdsn 'git diff --staged --name-status'
# git remote
abbr grv 'git remote -v'
abbr gup 'git pull -r && git fetch -p origin && remove-merged-git-branches && git remote | grep -v origin | xargs -L1 git fetch -p'

abbr ppy 'pyenv virtualenv (pyenv versions --skip-envs --skip-aliases --bare | sort -V | tail -n1) (basename $PWD) && pyenv local (basename $PWD) && pip install -U pip setuptools'

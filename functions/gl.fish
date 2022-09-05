if not set -q GL_BASE_DIR
    set GL_BASE_DIR $HOME/src
end

if not set -q GL_HOST
    set GL_HOST gitlab.com
end

function gl
  set -l repo ""
  set git_host $GL_HOST

  if [ (count $argv) -eq 1 ]
    set repo $argv[1]
  else if [ (count $argv) -eq 2 ]
    set repo $argv[1]/$argv[2]
  else if [ (count $argv) -eq 3 ]
    set repo $argv[1]/$argv[2]
    set git_host $argv[3]
  else
    echo "USAGE: gl <user>[/]<repo> [<host>]"
    return -1
  end

  set repo (string replace "https://$git_host/" "" $repo | string replace "git@$git_host:" "" | string trim -c "/")

  set -l path $GL_BASE_DIR/$git_host/$repo
  if not test -d $path
    git clone --recursive git@$git_host:$repo.git $path
  end

  cd $path
end

alias c=clear
alias ranger='ranger --choosedir=$HOME/.rangerdir; cd (cat $HOME/.rangerdir)'

alias urldecode='python -c "import sys, urllib as ul; print(ul.unquote_plus(sys.argv[1]))"'
alias urlencode='python -c "import sys, urllib as ul; print(ul.quote_plus(sys.argv[1])"'

alias man vman

alias n notify

alias timestamp='date +%s'

alias ':q' exit

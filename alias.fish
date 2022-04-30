alias ranger='ranger --choosedir=$HOME/.rangerdir; cd (cat $HOME/.rangerdir)'
alias c=clear

alias urldecode='python -c "import sys, urllib as ul; print(ul.unquote_plus(sys.argv[1]))"'
alias urlencode='python -c "import sys, urllib as ul; print(ul.quote_plus(sys.argv[1])"'

alias n notify

alias timestamp='date +%s'

alias ':q' exit

alias blkid '$HOME/.cargo/bin/grc-rs blkid';
alias curl '$HOME/.cargo/bin/grc-rs curl';
alias df '$HOME/.cargo/bin/grc-rs df';
alias diff '$HOME/.cargo/bin/grc-rs diff';
alias docker '$HOME/.cargo/bin/grc-rs docker';
alias du '$HOME/.cargo/bin/grc-rs du';
alias env '$HOME/.cargo/bin/grc-rs env';
alias fdisk '$HOME/.cargo/bin/grc-rs fdisk';
alias findmnt '$HOME/.cargo/bin/grc-rs findmnt';
alias free '$HOME/.cargo/bin/grc-rs free';
alias gcc '$HOME/.cargo/bin/grc-rs gcc';
alias getfacl '$HOME/.cargo/bin/grc-rs getfacl';
alias id '$HOME/.cargo/bin/grc-rs id';
alias ip '$HOME/.cargo/bin/grc-rs ip';
alias iptables '$HOME/.cargo/bin/grc-rs iptables';
alias last '$HOME/.cargo/bin/grc-rs last';
alias lsattr '$HOME/.cargo/bin/grc-rs lsattr';
alias lsblk '$HOME/.cargo/bin/grc-rs lsblk';
alias lsmod '$HOME/.cargo/bin/grc-rs lsmod';
alias lspci '$HOME/.cargo/bin/grc-rs lspci';
alias mount '$HOME/.cargo/bin/grc-rs mount';
alias ping '$HOME/.cargo/bin/grc-rs ping';
alias ps '$HOME/.cargo/bin/grc-rs ps';
alias ss '$HOME/.cargo/bin/grc-rs ss';
alias stat '$HOME/.cargo/bin/grc-rs stat';
alias sysctl '$HOME/.cargo/bin/grc-rs sysctl';
alias systemctl '$HOME/.cargo/bin/grc-rs systemctl';
alias tune2fs '$HOME/.cargo/bin/grc-rs tune2fs';
alias uptime '$HOME/.cargo/bin/grc-rs uptime';
alias vmstat '$HOME/.cargo/bin/grc-rs vmstat';
alias docker '$HOME/.cargo/bin/grc-rs docker';
alias go '$HOME/.cargo/bin/grc-rs go';

export LANG=en_US.UTF-8

alias vi=vim
alias ls="ls --color=tty"

export PATH=~/bin:$PATH

alias grep='grep --color -s --exclude='\''*.phptidybak~'\'' -I --exclude-dir={.bzr,CVS,.git,.hg,.svn}'
alias grpe='grep'

alias dstat='dstat -alp --top-cpu --top-cputime-avg 5 1500'


#[[ $- == *i* ]] && \
#    eval "$(direnv hook zsh)"

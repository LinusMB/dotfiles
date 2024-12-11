case $- in
    *i*) ;;
    *) return ;;
esac

. /usr/share/bash-completion/bash_completion

HISTCONTROL=ignoreboth
HISTSIZE=1000
HISTFILESIZE=2000

shopt -s histappend
shopt -s checkwinsize
shopt -s globstar
shopt -s dotglob

export TERM=xterm-256color

unalias -a
alias cd..='cd ..'
alias ls='ls -aF --group-directories-first'
alias ll='ls -alh'
alias df='df -h'
alias free='free -h'

PROMPT_COMMAND=__prompt_command

__prompt_command() {
    local B=$(git rev-parse --abbrev-ref HEAD 2>/dev/null)

    PS1="\W"
    if [ -n "$B" ]; then
        PS1+=":git(${B})"
    fi

    if [ -n "$SSH_CONNECTION" ]; then
        PS1+="> "
    elif [ $EUID -eq 0 ]; then
        PS1+="# "
    else
        PS1+="\$ "
    fi
}

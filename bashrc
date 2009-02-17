#Shell Options
shopt -s cdspell
shopt -s checkwinsize
shopt -s histappend
shopt -s extglob 
shopt -s progcomp
complete -cf sudo

#Aliases
alias ls='ls -h --color=auto'
alias ll='ls -l'
alias lh='ls -lt $@ | head -10'
alias grep='grep --color'
alias quickweb='python -m SimpleHTTPServer'

#Helper Functions
function wz() { 
  wget "$1" -O- | tar xzf - 
}
function wj() { 
  wget "$1" -O- | tar xjf - 
}
function confmake() {
  ./configure "$@" && make
}

export TD="$HOME/tmp/$(date +'%m-%d-%Y')"
function td(){
    td=$TD
    if [ ! -z "$1" ]; then
        td="$HOME/tmp/$(date -d "$1 days" +'%m-%d-%Y')";
    fi
    if [ ! -d $td ]; then
        mkdir -p $td
        unlink $HOME/tmp/latest; ln -s $td $HOME/tmp/latest
    fi
    cd $td; unset td
}

#Shell Environment Variables
export PATH="${HOME}/bin:${HOME}/.local/bin:/usr/local/bin:/usr/local/sbin:/usr/games:${PATH}:/usr/sbin:/sbin"
export EDITOR="vim"
export VISUAL="vim"
eval $(dircolors -b) # export LS_COLORS
export LC_ALL="$LANG"
export PYTHONSTARTUP="${HOME}/.pythonrc"
[[ -d /usr/share/doc/python ]] && export PYTHONDOCS="/usr/share/doc/python:$PYTHONDOCS"
export HISTCONTROL=ignoredups
export DOTFILES="${HOME}/.dotfiles"
#export CDPATH=".:~"

#Colorful prompt
if [ "$PS1" ]; then
    case "$TERM" in
	rxvt*)
        PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/~}"; echo -ne "\007"'
        ;;
	xterm*)
        PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/~}"; echo -ne "\007"'
        ;;
    esac
    #Check to see if im local or remote
    if [[ -n $(ps -ef |grep "sshd: \(mkemp2\|matt\)") ]]; then
        #Remote
        PS1='\[\033[01;35m\]\u@\h\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\]\$ '
    else
        #Local
        PS1='\[\033[01;32m\]\u@\h\[\033[00m\] \[\033[01;34m\]\w\[\033[00m\]\$ '
    fi

    . $DOTFILES/j/j.sh
fi

#Optional stuffs
[[ -f /etc/bash_completion ]] && . /etc/bash_completion
[[ -f /usr/bin/keychain ]] && eval $(keychain --eval -q id_rsa)

#Include local changes if available
[[ -f $HOME/.bashrc.local ]] && . "$HOME/.bashrc.local"

#New 4.0 options
if [[ ${BASH_VERSION::3} == '4.0' ]]; then
    export PROMPT_DIRTRIM=2
    shopt -s dirspell
    shopt -s globstar
fi

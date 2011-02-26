
#Shell Options
shopt -s cdspell
shopt -s checkwinsize
shopt -s histappend
shopt -s extglob 
shopt -s progcomp
complete -cf sudo

#Aliases
#alias ls='ls -h --color=auto'
alias ll='ls -l'
alias lh='ls -lt $@ | head -10'
alias grep='grep --color'
alias quickweb='python -m SimpleHTTPServer'
alias cal='cal | sed "s/.*/ & /;s/ \($(date +%e)\) / $(echo -e "\033[01;31m")\1$(echo -e "\033[00m") /"'

#Helper Functions
function wz() { 
  wget "$1" -O- | tar xzf - 
}
function wj() { 
  wget "$1" -O- | tar xjf - 
}
function confmake() {
  ./configure "$@" && make -j3
}

#Shell Environment Variables
export PATH="${HOME}/bin:${HOME}/.local/bin:${PATH}"
export EDITOR="vim"
export VISUAL="vim"
which dircolors >/dev/null 2>&1 && eval $(dircolors -b) # export LS_COLORS
export LC_ALL="$LANG"
export PYTHONSTARTUP="${HOME}/.pythonrc"
export HISTCONTROL=ignoredups
export DOTFILES="${HOME}/.dotfiles"
export INPUTRC=~/.inputrc

#Colorful prompt
if [ "$PS1" ]; then
    case "$TERM" in
	rxvt*)
        PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/~}"; echo -ne "\007";'
        ;;
	xterm*)
        PROMPT_COMMAND='echo -ne "\033]0;${USER}@${HOSTNAME%%.*}:${PWD/#$HOME/~}"; echo -ne "\007";'
        ;;
    esac

    D=$'\e[37m'
    PINK=$'\e[35m'
    GREEN=$'\e[32m'
    ORANGE=$'\e[33m'
    RESET=$'\e[0m'

    #Check to see if im local or remote
    if [[ -n $(ps -ef |grep "sshd: \(mkemp\|mkemp2\|matt\)") ]]; then
        #Remote
        PS1='\n┌─[${GREEN}\h${D}][${ORANGE}\w${D}]${PINK} ${D}\n└─> ${RESET}'
    else
        #Local
        PS1='\n┌─[${PINK}\h${D}][${ORANGE}\w${D}]${PINK} ${D}\n└─> ${RESET}'
    fi
fi

#Optional stuffs
[[ -f /usr/bin/keychain ]] && eval $(keychain --eval -q id_rsa)

#Include local changes if available
[[ -f $HOME/.bashrc.local ]] && . "$HOME/.bashrc.local"

#New 4.0 options
if [[ ${BASH_VERSION::1} == '4' ]]; then
    export PROMPT_DIRTRIM=2
    shopt -s dirspell
    shopt -s globstar
    shopt -s checkjobs
fi

#====virtualenv Wrapper====
if [ -f $(which virtualenvwrapper.sh) ]; then
  export WORKON_HOME=$HOME/.virtualenvs
  export PIP_VIRTUALENV_BASE=$WORKON_HOME

  #Set up virtualenvwraper
  . $(which virtualenvwrapper.sh)

  _virtualenvs()
  {
      local cur="${COMP_WORDS[COMP_CWORD]}"
      COMPREPLY=( $(compgen -W "`ls $WORKON_HOME`" -- ${cur}) )
  }

  complete -o default -o nospace -F _virtualenvs workon
  complete -o default -o nospace -F _virtualenvs rmvirtualenv
fi

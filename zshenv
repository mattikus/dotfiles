export EDITOR="vim"
export VISUAL="vim -f"
export LC_ALL="$LANG"
export PYTHONSTARTUP="${HOME}/.pythonrc"
export DOTFILES="${HOME}/.dotfiles"
export INPUTRC="${HOME}/.inputrc"
export HISTFILE="${HOME}/.zsh_history"
export HISTSIZE=30000
export SAVEHIST=30000
export HIST_IGNORE_DUPS=true
export HIST_FIND_NO_DUPS=true

# Set up dircolors
[[ which -s dircolors ]] && eval $(dircolors -b ${HOME}/.dircolors) 

#Set up virtualenvwraper
if which -s virtualenvwrapper.sh; then
  export WORKON_HOME=${HOME}/.virtualenvs
  export PIP_VIRTUALENV_BASE=$WORKON_HOME
  export PIP_RESPECT_VIRTUALENV=true
  export VIRTUAL_ENV_DISABLE_PROMPT=true
  export VIRTUALENV_USE_DISTRIBUTE=true
  export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python
  [[ -d $WORKON_HOME ]] || mkdir -p $WORKON_HOME
  source $(which virtualenvwrapper.sh)
fi

#Aliases
case "$(uname -s)" in
  'Darwin')
    alias ls='ls -GFh'
    ;;
  'Linux')
    alias ls='ls --color=always -Fh'
    ;;
  'NetBSD')
    [[ which -s colorls ]] && alias ls='colorls -GFh'
    ;;
esac


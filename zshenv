# ENV VARS
export EDITOR=vim
export VISUAL="vim -f"
export LC_ALL=$LANG
export PYTHONSTARTUP=~/.pythonrc
export DOTFILES=~/.dotfiles
export INPUTRC=~/.inputrc
export HISTFILE=~/.zsh_history
export HISTSIZE=30000
export SAVEHIST=30000
export HIST_IGNORE_DUPS=true
export HIST_IGNORE_SPACE=true
export HIST_FIND_NO_DUPS=true

# If we have a local struture, use it.
if [[ -d ~/.local ]]; then
    export LD_LIBRARY_PATH="~/.local/lib:$LD_LIBRARY_PATH"
    export LD_RUN_PATH="~/.local/lib:$LD_RUN_PATH"
    export PKG_CONFIG_PATH="~/.local/lib/pkgconfig:$PKG_CONFIG_PATH"

    export LDFLAGS="-L~/.local/lib -L/lib64 -L/usr/lib64 $LDFLAGS"
    export CFLAGS="-I~/.local/include -I/include -I/usr/include $CFLAGS"
    export CPPFLAGS="$CFLAGS"

    path=(~/.local/bin $path)
    export MANPATH="~/.local/man:$MANPATH"
fi

#Set up virtualenvwraper
if which virtualenvwrapper.sh &> /dev/null; then
  export WORKON_HOME=~/.virtualenvs
  [[ -d $WORKON_HOME ]] || mkdir -p $WORKON_HOME
  export VIRTUAL_ENV_DISABLE_PROMPT=true
  export VIRTUALENV_DISTRIBUTE=true
  . $(which virtualenvwrapper.sh)
fi


# Source my local configs
[[ -f ~/.zlocal ]] && . ~/.zlocal

# Add my personal bin to the front
path=(~/bin $path)

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
    export LD_LIBRARY_PATH="$HOME/.local/lib:$LD_LIBRARY_PATH"
    export LD_RUN_PATH="$HOME/.local/lib:$LD_RUN_PATH"
    export PKG_CONFIG_PATH="$HOME/.local/lib/pkgconfig:$PKG_CONFIG_PATH"

    export LDFLAGS="-L$HOME/.local/lib -L/lib64 -L/usr/lib64 $LDFLAGS"
    export CFLAGS="-I$HOME/.local/include -I/include -I/usr/include $CFLAGS"
    export CPPFLAGS="$CFLAGS"

    path=(~/.local/bin $path)
    export MANPATH="$HOME/.local/man:$MANPATH"
fi

# Add my personal bin to the front
path=(~/bin $path)

#Set up virtualenvwraper
if which virtualenvwrapper_lazy.sh &> /dev/null; then
  export WORKON_HOME=~/.virtualenvs
  [[ -d $WORKON_HOME ]] || mkdir -p $WORKON_HOME
  export VIRTUAL_ENV_DISABLE_PROMPT=true
  . $(which virtualenvwrapper_lazy.sh)
fi


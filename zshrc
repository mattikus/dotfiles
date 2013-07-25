# Add extra completions to path if they exist
[[ -d /usr/local/share/zsh-completions ]] && fpath=(/usr/local/share/zsh-completions $fpath)
[[ -d "${HOME}/.zcompletions" ]] && fpath=("${HOME}/.zcompletions" $fpath)
[[ -d "${HOME}/.zfunc" ]] && fpath=("${HOME}/.zfunc" $fpath)

# Load up functions for use in my configs
autoload -Uz colors compinit zmv vcs_info url-quote-magic
colors; compinit;

# ENV VARS
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
export HIST_IGNORE_SPACE=true
export HIST_FIND_NO_DUPS=true

#Set up virtualenvwraper
if which virtualenvwrapper.sh &> /dev/null; then
  export WORKON_HOME=${HOME}/.virtualenvs
  export VIRTUAL_ENV_DISABLE_PROMPT=true
  export VIRTUALENV_DISTRIBUTE=true
  export VIRTUALENVWRAPPER_PYTHON=/usr/bin/python
  [[ -d $WORKON_HOME ]] || mkdir -p $WORKON_HOME
  source $(which virtualenvwrapper.sh)
fi

# Add my personal bin to the front
path=(~/bin $path)

# Set options
setopt append_history
setopt auto_list
setopt complete_aliases
setopt complete_in_word
setopt extended_glob
setopt interactive_comments
setopt nobeep
setopt nohup
setopt notify
setopt prompt_subst
setopt share_history
setopt vi

# Check to see if we're sshed into a box
if [[ -z "$SSH_TTY" ]]; then
  eval ucolor='%F{cyan}'
else
  eval ucolor='%F{magenta}'
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

# set up vcs_info for prompt
local FMT_BRANCH="%F{green}%s:%b%f%u%c" # e.g. master¹²
local FMT_ACTION="(%F{cyan}%a%f})"   # e.g. (rebase-i)
local FMT_PATH="%R%F{yellow}/%S"              # e.g. ~/repo/subdir
zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:*:prompt:*' check-for-changes true
zstyle ':vcs_info:*:prompt:*' unstagedstr '%F{red}*%f'  # display ¹ if there are unstaged changes
zstyle ':vcs_info:*:prompt:*' stagedstr '%F{green}*%f'    # display ² if there are staged changes
zstyle ':vcs_info:*:prompt:*' actionformats "${FMT_BRANCH}${FMT_ACTION}"
zstyle ':vcs_info:*:prompt:*' formats       "${FMT_BRANCH}"
zstyle ':vcs_info:*:prompt:*' nvcsformats   "" ""


# Executed before each command
function preexec() {
  case "$TERM" in
    xterm*|*rxvt*|gnome*)
      print -n "\e]0;$1\a"
      ;;
  esac
}

# Executed before each prompt
function precmd() {
  case "$TERM" in
    xterm*|*rxvt*|gnome*)
      print -Pn "\e]0;%n@%m: %~\a"
      ;;
    screen*)
      print -Pn "\e]0;%n@%m: %~\a"
      print -Pn "\e]2;%m\a"
      ;;
  esac

  vcs_info 'prompt'
  if [[ -n "${vcs_info_msg_0_}" ]]; then
      vcs_stuff=" ${vcs_info_msg_0_}%f"
  else
      unset vcs_stuff
  fi

  if [[ -n "$VIRTUAL_ENV" ]]; then
    virtual_env=" %F{blue}$(basename "$VIRTUAL_ENV")%f"
  else
    unset virtual_env
  fi
}

### ZLE Bits ###
zle -N self-insert url-quote-magic

export PROMPT='%(?,%F{green}✓%f,%F{red}✗%f) %F{blue}%D{%H:%M}%f $ucolor%m%f %F{green}%40<..<%~%f${vcs_stuff}${virtual_env} %% '

# Utility functions for downloading
function wz() { 
  if $(which wget &>/dev/null); then
    wget "$1" -O- | tar xz
  elif $(which curl &>/dev/null); then
    curl "$1" | tar xz
  fi
}

function wj() { 
  if $(which wget &>/dev/null); then
    wget "$1" -O- | tar xj
  elif $(which curl &>/dev/null); then
    curl "$1" | tar xj
  fi
}

function wJ() { 
  if $(which wget &>/dev/null); then
    wget "$1" -O- | tar xJ
  elif $(which curl &>/dev/null); then
    curl "$1" | tar xJ
  fi
}

# Source my local configs
[[ -f "${HOME}/.zlocal" ]] && . "${HOME}/.zlocal"

# Add extra completions to path if they exist
[[ -d /usr/local/share/zsh-completions ]] && fpath=(/usr/local/share/zsh-completions $fpath)
[[ -d ~/.zcompletions ]] && fpath=(~/.zcompletions $fpath)
[[ -d ~/.zfunc ]] && fpath=(~/.zfunc $fpath)

# Load up functions for use in my configs
autoload -Uz colors compinit zmv vcs_info url-quote-magic edit-command-line
colors; compinit;

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
esac

# set up vcs_info for prompt
zstyle ':vcs_info:*' enable git svn
zstyle ':vcs_info:*' formats '%s:%b'
zstyle ':vcs_info:git*' actionformats '%b|%a'
zstyle ':vcs_info:svn*' branchformat 'r%r'

function git_dirty() {
    # check if we're in a git repo
    command git rev-parse --is-inside-work-tree &>/dev/null || return
    # check if it's dirty
    command git diff --quiet --ignore-submodules HEAD &>/dev/null; [ $? -eq 1 ] && echo '*'
}

# Executed before each prompt
function precmd() {
  vcs_info
  if [[ -n "${vcs_info_msg_0_}" ]]; then
      vcs_stuff=" ${vcs_info_msg_0_}$(git_dirty)%f"
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
zle -N edit-command-line
bindkey -M vicmd v edit-command-line

export PROMPT='%F{blue}%D{%H:%M}%f $ucolor%m%f %F{green}%40<..<%~%f${vcs_stuff}${virtual_env} %(?,%F{green},%F{red})%%%f '

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
[[ -f ~/.zlocal ]] && . ~/.zlocal

# Load up functions for use in my configs
autoload -Uz colors compinit promptinit zmv vcs_info url-quote-magic
colors; compinit; promptinit;

export PATH="${HOME}/bin:${PATH}"

# Source my local configs
[ -f "${HOME}/.zshrc.local" ] && . "${HOME}/.zshrc.local" # deprecated
[ -f "${HOME}/.zlocal" ] && . "${HOME}/.zlocal"

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

### Completion Bits ###

zstyle ':completion:*' completer _expand _complete _ignored _match _approximate _prefix
zstyle ':completion:*' file-sort modification
zstyle ':completion:*' format '- %d -'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' matcher-list 'm:{[:lower:]}={[:upper:]}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'
zstyle ':completion:*' max-errors 1
zstyle ':completion:*' menu select=3
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' verbose true
zstyle ':completion:*' accept-exact yes
zstyle ':completion:*' squeeze-slashes true

## cd not select parent dir. 
zstyle ':completion:*:cd:*' ignore-parents parent pwd

#set up vcs_info
local FMT_BRANCH="[%{$fg[green]%}%s:%b%{$fg[red]%}%u%c%%{$reset_color%}]" # e.g. master¹²
local FMT_ACTION="(%{$fg[cyan]%}%a%{$reset_color%})"   # e.g. (rebase-i)
local FMT_PATH="%R%{$fg[yellow]%}/%S"              # e.g. ~/repo/subdir
zstyle ':vcs_info:*' enable git svn hg bzr
zstyle ':vcs_info:*:prompt:*' check-for-changes true
zstyle ':vcs_info:*:prompt:*' unstagedstr '¹'  # display ¹ if there are unstaged changes
zstyle ':vcs_info:*:prompt:*' stagedstr '²'    # display ² if there are staged changes
zstyle ':vcs_info:*:prompt:*' actionformats "${FMT_BRANCH}${FMT_ACTION}"
zstyle ':vcs_info:*:prompt:*' formats       "${FMT_BRANCH}"
zstyle ':vcs_info:*:prompt:*' nvcsformats   "" ""

# Auto-rehashing.  Try command completion, if fails, rehash
function compctl_rehash { hash -r; reply=() }
compctl -C -c + -K compctl_rehash + -c

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

### ZLE Bits ###

# If I am using vi keys, I want to know what mode I'm currently using.
# zle-keymap-select is executed every time KEYMAP changes.
# From http://zshwiki.org/home/examples/zlewidgets
function zle-line-init zle-keymap-select {
    VIMODE="${${KEYMAP/vicmd/c}/(main|viins)/i}"
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

zle -N self-insert url-quote-magic


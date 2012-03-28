# Load up functions for use in my configs
autoload -Uz colors compinit promptinit zmv vcs_info url-quote-magic
colors; compinit; promptinit;

# Source my local configs
[ -f "${HOME}/.zshrc.local" ] && . "${HOME}/.zshrc.local" # deprecated
[ -f "${HOME}/.zlocal" ] && . "${HOME}/.zlocal"

# Set options
setopt appendhistory
setopt autolist
setopt cdablevars
setopt completealiases
setopt completeinword
setopt extended_glob
setopt interactivecomments
setopt nobeep
setopt nohup
setopt notify
setopt prompt_subst
setopt vi

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

# Completion styles
# allow approximate
zmodload zsh/complist
zstyle ':completion:*' completer _complete _match _approximate 
zstyle ':completion:*:match:*' original only
zstyle -e ':completion:*:approximate:*' max-errors 'reply=( $(( ($#PREFIX + $#SUFFIX) / 3 )) )'
zstyle ':completion:*:descriptions' format "- %d -"
zstyle ':completion:*:corrections' format "- %d - (errors %e})"
zstyle ':completion:*:default' list-prompt '%S%M matches%s'
zstyle ':completion:*' group-name ''
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*:manuals.(^1*)' insert-sections true
zstyle ':completion:*' menu autoselect
zstyle ':completion:*' verbose yes
zstyle ':completion:*' accept-exact yes
zstyle ':completion:*' expand yes
zstyle ':completion:*' use-cache 1
zstyle ':completion::complete:*' cache-path ~/.zsh_cache_$HOST
zstyle ':completion:*' use-perl yes
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
compctl -g "*.tar *.tgz *.tz *.tar.Z *.tar.bz2 *.tZ *.tar.gz" + -g "*(-/) .*(-/)" tar

# tab completion for PID :D
zstyle ':completion:*:*:kill:*' menu yes select
zstyle ':completion:*:kill:*' force-list always

# cd not select parent dir. 
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

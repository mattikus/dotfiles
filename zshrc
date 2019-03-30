export EDITOR=vim

# Set up the prompt

autoload -Uz promptinit colors
colors; promptinit
export PROMPT='%F{blue}%D{%H:%M}%f %F{cyan}%m%f %F{green}%40<..<%~%f %(?,%F{green},%F{red})%%%f '

setopt histignorealldups sharehistory

# Use emacs keybindings even if our EDITOR is set to vi
bindkey -v

### ZLE Bits ###
autoload -Uz url-quote-magic edit-command-line
zle -N self-insert url-quote-magic
zle -N edit-command-line
bindkey -M vicmd v edit-command-line
# Put Ctrl-R in insert mode as reverse history search
bindkey -M viins '^R' history-incremental-search-backward

# Use modern completion system
autoload -Uz compinit
compinit

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' menu select=2
eval "$(dircolors -b)"
zstyle ':completion:*:default' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=* l:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle ':completion:*' use-compctl false
zstyle ':completion:*' verbose true

zstyle ':completion:*:*:kill:*:processes' list-colors '=(#b) #([0-9]#)*=0=01;31'
zstyle ':completion:*:kill:*' command 'ps -u $USER -o pid,%cpu,tty,cputime,cmd'

# History stuffs
HISTFILE="$HOME/.zsh_history"
HISTSIZE=10000000
SAVEHIST=10000000
setopt BANG_HIST                 # Treat the '!' character specially during expansion.
setopt EXTENDED_HISTORY          # Write the history file in the ":start:elapsed;command" format.
setopt INC_APPEND_HISTORY        # Write to the history file immediately, not when the shell exits.
setopt SHARE_HISTORY             # Share history between all sessions.
setopt HIST_EXPIRE_DUPS_FIRST    # Expire duplicate entries first when trimming history.
setopt HIST_IGNORE_DUPS          # Don't record an entry that was just recorded again.
setopt HIST_IGNORE_ALL_DUPS      # Delete old recorded entry if new entry is a duplicate.
setopt HIST_FIND_NO_DUPS         # Do not display a line previously found.
setopt HIST_IGNORE_SPACE         # Don't record an entry starting with a space.
setopt HIST_SAVE_NO_DUPS         # Don't write duplicate entries in the history file.
setopt HIST_REDUCE_BLANKS        # Remove superfluous blanks before recording entry.
#setopt HIST_VERIFY               # Don't execute immediately upon history expansion.
setopt HIST_BEEP                 # Beep when accessing nonexistent history.

# aliases
alias ls='ls --color=auto -Fh'
alias grep='grep --color=auto'

# Set up local paths
path=(~/bin ~/.local/bin ~/go/bin $path)

[[ -f /usr/share/doc/fzf/examples/key-bindings.zsh ]] && . /usr/share/doc/fzf/examples/key-bindings.zsh
[[ -f /usr/share/zsh/vendor-completions/_fzf ]] && . /usr/share/zsh/vendor-completions/_fzf

# Add rust to path if it exists
[[ -d ~/.cargo/bin ]] && path=(~/.cargo/bin $path)

if [[ -x $(which nvim) ]]; then
  alias vim=nvim
fi

# Set my autoload path so i can have the latest greatest even on older zsh
[[ $fpath = *${HOME}* ]] || fpath=("${HOME}/.zsh/functions" $fpath)

# Load up functions for use in my configs
autoload -Uz colors compinit promptinit zmv vcs_info url-quote-magic
colors; compinit; promptinit;
zle -N self-insert url-quote-magic

# Source my configs
[ -f "${HOME}/.zshrc.local" ] && source "${HOME}/.zshrc.local"
ZHOME="${HOME}/.zsh"
source "${ZHOME}/environ_alias"
source "${ZHOME}/style"
source "${ZHOME}/personal_functions"

# Set options
setopt appendhistory
setopt extended_glob
setopt notify
setopt cdablevars
setopt interactivecomments
setopt nohup
setopt vi
unsetopt beep

# Create my git configuration unless it's already up-to-date.
if [ -f $DOTFILES/gitconfig.tmpl ] && [ -f $HOME/.github-token ]; then
  ztmpl $DOTFILES/gitconfig.tmpl $HOME/.gitconfig
fi

# Create my prompt
setprompt

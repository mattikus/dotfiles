ZHOME="${HOME}/.zsh"
source "${ZHOME}"/*

autoload -Uz colors compinit promptinit zmv vcs_info url-quote-magic
colors; compinit; promptinit;
zle -N self-insert url-quote-magic

# Set options
setopt appendhistory 
setopt extendedglob 
setopt notify 
setopt cdablevars
setopt interactivecomments
setopt nohup
setopt vi
unsetopt beep

# Create my git configuration unless it's already up-to-date.
ztmpl ~/.gitconfig

# Create my prompt
setprompt


# Executed before each prompt
function precmd() {
  vcs_info 'prompt'
  case "$TERM" in
    xterm*|*rxvt*|gnome*)
      print -Pn "\e]0;%n@%m: %~\a"
      ;;
    screen*)
      print -Pn "\e]0;%n@%m: %~\a"
      print -Pn "\e]2;%m\a"
      ;;
  esac
  if [ -n "$VIRTUAL_ENV" ]; then
    virtual_env=[%{$fg[blue]%}$(basename "$VIRTUAL_ENV")%{$reset_color%}]
  else
    unset virtual_env
  fi
}

# Executed before each command
function preexec() {
  case "$TERM" in
    xterm*|*rxvt*|gnome*)
      print -n "\e]0;$1\a"
      ;;
  esac
}

# Check to see if we're sshed into a box
if [ -z "$SSH_TTY" ]; then
  eval ucolor='%{$fg[cyan]%}'
else
  eval ucolor='%{$fg[magenta]%}'
fi

export PROMPT='┌─[$ucolor%m%{${reset_color}%}][%{$fg[green]%}%40<..<%~%{${reset_color}%}][%{$fg[yellow]%}${VIMODE}%{$reset_color%}]${vcs_info_msg_0_}${virtual_env}
└─> '

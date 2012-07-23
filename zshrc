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
    virtual_env=[%F{blue}$(basename "$VIRTUAL_ENV")%f]
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
  eval ucolor='%F{cyan}'
else
  eval ucolor='%F{magenta}'
fi

export PROMPT='[$ucolor%m%f %F{green}%40<..<%~%f][%F{yellow}${VIMODE}%f][ '
export RPROMPT='%f${vcs_info_msg_0_}${virtual_env}] %f%F{green}%D{%H:%M}%f'

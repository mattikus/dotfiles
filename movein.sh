#!/bin/bash

movein() {
    git archive --format tar --prefix .dotfiles/ HEAD | ssh "$1" "
    if [[ -d .dotfiles ]]; 
      then rm -r .dotfiles;
    fi; 
    tar x && \
    .dotfiles/create_symlinks.sh"
}
usage() {
  echo "Archives and copies the repo to a machine that does not have mercurial"
  echo "Usage: $0 hostname"
}

if [[ $1 =~ "-h" || $1 =~ "--help" ]]; then
  usage
elif [[ -n $1 ]]; then
  movein "$1"
else
  echo -e "Error: requires at least one argument\n"
  usage
fi


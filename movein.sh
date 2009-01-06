#!/bin/bash

movein() {
  hg archive -ttgz /tmp/dotfiles.tar.gz
  cat /tmp/dotfiles.tar.gz | ssh "$1" "
    if [[ -d .dotfiles ]]; 
      then rm -r .dotfiles;
    fi; 
    tar xz && \
    mv {,.}dotfiles && \
    .dotfiles/create_symlinks.sh"

  #cleanup
  rm /tmp/dotfiles.tar.gz
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


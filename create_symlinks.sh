#!/bin/bash

set -euo pipefail

pathdir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"

special_dirs=(ssh)
non_dot_dirs=(bin)

echo -n "Creating symlinks"
for filepath in ${pathdir}/*; do
  file="$(basename ${filepath})"

  # Don't symlink this file since that would be dumb
  if [[ "${BASH_SOURCE[0]}" == "$file" ]]; then
    continue
  fi

  # Handle special dirs where we want to link sub-components but not the actual parent directory
  if [[ " ${special_dirs[*]} ${non_dot_dirs[*]} " =~ " $(basename $file) " ]]; then
    prefix="."
    # Don't add a . for non_dot_dirs
    if [[ " ${non_dot_dirs[*]} " =~ " $(basename $file) " ]]; then
      prefix=""
    fi

    for subfilepath in $filepath/*; do
      subfile="$(basename ${subfilepath})"
      mkdir -p "${HOME}/${prefix}${file}"
      ln -s -f $subfilepath ${HOME}/${prefix}${file}/${subfile}
    done

  # Normal dotfile symlinkage
  else
    if [[ -d "$pathdir/$file" ]]; then
      rm -f "$HOME/.${file}"
    fi
    ln -s -f -n "${filepath}" "${HOME}/.${file}"
  fi

  echo -n "."
done
echo "done!"

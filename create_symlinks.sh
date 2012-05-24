#!/bin/bash

path=$HOME/.dotfiles
pathdir=$(echo $path | sed -e 's/.*\///')
special_dirs=(ssh)
non_dot_dirs=(bin)

echo -n "Creating symlinks"
cd "$path"
for file in *; do
    if [[ $(basename $0) == "$file" ]]; then
        continue
    elif [[ -n $(echo ${special_dirs[*]} | grep "$file") ]]; then
        (for subfile in $file/*; do
            mkdir -p "$HOME/.$(dirname $subfile)"
            cd ~/."$(dirname $subfile)"
            ln -s -f "../$pathdir/$subfile"
            echo -n "."
        done)
    elif [[ -n $(echo ${non_dot_dirs[*]} | grep "$file") ]]; then
        (for subfile in "$file/"*; do
            mkdir -p ~/"$(dirname $subfile)"
            cd ~/"$(dirname $subfile)"
            ln -s -f "../$pathdir/$subfile"
            echo -n "."
        done)
    else
        (cd
        if [[ -d "$pathdir/$file" ]]; then
            rm -f "$HOME/.$file" && ln -s -f -n "$pathdir/$file" ".$file"
            echo -n "."
        else
            ln -s -f "$pathdir/$file" ".$file"
            echo -n "."
        fi)
    fi
done
echo "done"

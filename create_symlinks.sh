#!/bin/bash

#path=$(dirname $0)
path=$HOME/.dotfiles
pathdir=$(echo $path | sed -e 's/.*\///')

excludes=(create_symlinks.sh movein.sh config.h gitconfig.tmpl)
special_dirs=(ssh)
non_dot_dirs=(bin)
config_dirs=(awesome openbox)

echo -n "Creating symlinks..."
cd "$path"
for file in *; do
    if [[ -n $(echo ${special_dirs[*]} | grep "$file") ]]; then
        (
        for subfile in $file/*; do
            mkdir -p ~/."$(dirname $subfile)"
            cd ~/."$(dirname $subfile)"
            ln -s -f ../"$pathdir"/"$subfile"
        done
        )
    elif [[ -n $(echo ${config_dirs[*]} | grep "$file") ]]; then
        (
        mkdir -p ~/.config
        cd ~/.config
        ln -s -f ../"$pathdir"/"$file"
        )
    elif [[ -n $(echo ${non_dot_dirs[*]} | grep "$file") ]]; then
        (
        for subfile in "$file/"*; do
            mkdir -p ~/"$(dirname $subfile)"
            cd ~/"$(dirname $subfile)"
            ln -s -f ../"$pathdir"/"$subfile"
        done
        )
    elif [[ -z $(echo ${excludes[*]} | grep "$file") ]]; then
        (
        cd ~
        if [[ -d "$pathdir/$file" ]]; then
            rm -f ~/."$file"
            ln -s -f -n "$pathdir/$file" ."$file"
        else
            ln -s -f "$pathdir/$file" ".$file"
        fi
        )
    fi
done
echo "done"

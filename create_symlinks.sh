#!/bin/bash

path=$HOME/.dotfiles
pathdir=$(echo $path | sed -e 's/.*\///')

excludes=(create_symlinks.sh movein.sh config.h gitconfig.tmpl archive)
special_dirs=(ssh)
non_dot_dirs=(bin)
config_dirs=(awesome openbox)

function tmpl() {
  # $1 = template; $2 = output file
  cat $1 | perl -p -e 's/\$\{([^}]+)\}/defined $ENV{$1} ? $ENV{$1} : $&/eg' > $2
}

# Create my git configuration unless it's already up-to-date.
if [ -f $DOTFILES/gitconfig.tmpl ] && [ -f $HOME/.github-token ]; then
  GITHUB_TOKEN=$(cat $HOME/.github-token) tmpl $DOTFILES/gitconfig.tmpl $HOME/.gitconfig
fi


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

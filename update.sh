#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

git pull origin master;

function doIt() {
   # update home directory
   rsync --exclude ".git/" --exclude ".DS_Store" --exclude "bootstrap.sh" \
      --exclude "README.md" --exclude "LICENSE-MIT.txt" -avh --no-perms . ~;

   # TODO: check for vim

   # TODO: check if vim has plugin manager

   # TODO: update vim plugins

   # TODO: check for zsh

   # TODO: check for oh-my-zsh
   

}

if [ "$1" = "--force" -o "$1" = "-f" ]; then
   doIt;
else
   read -p "This may overwrite existing files in your home directory. Are you sure? (y/n) " -n 1;
   echo "";
   if [[ $REPLY =~ ^[Yy]$ ]]; then
      doIt;
   fi;
fi;
unset doIt;

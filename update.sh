#!/usr/bin/env bash

cd "$(dirname "${BASH_SOURCE}")";

git pull origin master;

function doIt() {

   # check for vim
   if [ ! -e /usr/bin/vim ]; then
      echo "No vim found, please install before running update.sh."
      exit 1
   fi

   # check if vim has plugin manager
   if [ ! -e $HOME/.vim/autoload/plug.vim ]; then
      read -p "No plugin manager found, install vim-plug?" -n 1
      if [[ $REPLY =~ ^[Yy]$ ]]; then
         curl -fLo ~/.vim/autoload/plug.vim --create-dirs \
                https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
      fi
   fi

   # TODO: update vim plugins

   # check for zsh
   if [ ! -e /usr/bin/zsh ]; then
      echo "No zsh found, please install before running update.sh."
      exit 1
   fi

   # check for oh-my-zsh
   if [ ! -d $HOME/.oh-my-zsh ]; then
      read -p "No oh-my-zsh found, install?" -n 1
      if [[ $REPLY =~ ^[Yy]$ ]]; then
         sh -c "$(curl -fsSL https://raw.github.com/robbyrussell/oh-my-zsh/master/tools/install.sh)"
      fi
   fi

   # update home directory
   rsync --exclude ".git/" --exclude ".DS_Store" --exclude "update.sh" \
      --exclude "README.md" --exclude "LICENSE-MIT.txt" -avh --no-perms . ~;
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

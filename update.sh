#!/usr/bin/env bash

# find out absolute path to ourselves (http://stackoverflow.com/questions/4774054)
pushd `dirname $0` > /dev/null
DOTFILES=`pwd -P`
popd > /dev/null
echo "Switching to $DOTFILES"
cd "$DOTFILES"

git pull origin master;

function doIt() {

   # check for vim
   if [ ! -e /usr/bin/vim ]; then
      echo "No vim found, please install before running update.sh."
      exit 1
   fi

   # check for curl
   if [ ! -e /usr/bin/curl ]; then
      echo "No curl found, please install before running update.sh."
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

   # check for fish
   if [ ! -e /usr/bin/fish -a ! -e /bin/fish -a ! -e /usr/local/bin/fish ]; then
      echo "No fish found, please install before running update.sh."
      exit 1
   fi

   # check for oh-my-fish
   if [ ! -d $HOME/.config/omf ]; then
      read -p "No oh-my-fish found, install?" -n 1
      if [[ $REPLY =~ ^[Yy]$ ]]; then
         curl -L https://get.oh-my.fish | fish
	 omf install bobthefish
      fi
   fi

   # update home directory
   echo -ne "Updating home directory..."
   FILES=`find . -maxdepth 1 | grep -vEf exclude`
   cd $HOME
   for i in $FILES; do
      ln -sf "$DOTFILES/$i" .
   done
   ln -sf "$DOTFILES/.config/fish/fish.config" .config/fish/
   cd "$DOTFILES"
   echo "done."

   # install setup template, if not present
   if [ ! -e $HOME/.localsetup ]; then
      echo "Installing per-host setup template. Edit .localsetup to fit your needs."
      cp $DOTFILES/.localsetup $HOME/.localsetup
   fi

   # install vim template, if not present
   if [ ! -e $HOME/.localvimrc ]; then
      echo "Installing per-host vim template. Edit .localvimrc to fit your needs."
      cp $DOTFILES/.localvimrc $HOME/.localvimrc
   fi
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

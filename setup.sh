#/bin/bash

echo "Preparing"

touch ~/.bashrc ~/.vimrc
mkdir -p ~/.vim
mkdir -p ~/.vim/backup
mkdir -p ~/.vim/tmp
mkdir -p ~/.vim/colors

# Create tmp dir
mkdir tmp/

echo "Backing Up and moving configs"

cp ~/.bashrc ~/.bashrc~
cp .bashrc ~/.bashrc

cp -r ~/.vimrc ~/.vimrc~
cp -r ~/.vim ~/.vim~
cp .vimrc ~/.vimrc

echo "Installing Pathogen"

mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim


echo "Installing Deps"
echo "vim-airline"
echo -e "\033[0;32m Please run :helptags on first run \033[0m"

git clone https://github.com/vim-airline/vim-airline ~/.vim/bundle/vim-airline

echo "nerdtree"

git clone https://github.com/scrooloose/nerdtree.git ~/.vim/bundle/nerdtree

echo "mustang colour theme" 
git clone https://github.com/croaker/mustang-vim tmp/
cp tmp/colors/mustang.vim ~/.vim/colors/

echo "clearning up" 

rm -rf tmp/


echo "booyah, there you go!"

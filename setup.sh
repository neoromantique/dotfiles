#/bin/bash

GREEN='\033[0;32m'
RESET='\033[0m'


echo "Preparing"

touch ~/.bashrc ~/.vimrc
mkdir -p ~/.vim
mkdir -p ~/.vim/backup
mkdir -p ~/.vim/tmp
mkdir -p ~/.vim/colors

# Create tmp dir
mkdir tmp/

echo -e "${GREEN} Backing Up and moving configs ${RESET}"

cp ~/.bashrc ~/.bashrc~
cp .bashrc ~/.bashrc

cp -r ~/.vimrc ~/.vimrc~
cp -r ~/.vim ~/.vim~
cp .vimrc ~/.vimrc

echo -e "${GREEN} Installing Pathogen ${RESET}"

mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim


echo -e "${GREEN} Installing Deps ${RESET}"
echo -e "vim-airline"
echo -e "${GREEN} Please run :helptags on first run ${RESET}"

git clone https://github.com/vim-airline/vim-airline ~/.vim/bundle/vim-airline

echo -e "${GREEN} nerdtree ${RESET}"

git clone https://github.com/scrooloose/nerdtree.git ~/.vim/bundle/nerdtree

echo -e "${GREEN} mustang colour theme ${RESET}" 
git clone https://github.com/croaker/mustang-vim tmp/
cp tmp/colors/mustang.vim ~/.vim/colors/

echo -e "${GREEN} clearning up ${RESET}" 

rm -rf tmp/


echo -e "booyah, ${GREEN} there you go! ${RESET}"

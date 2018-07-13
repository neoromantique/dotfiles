#/bin/bash

GREEN='\033[0;32m'
RESET='\033[0m'


read -p "Delete old backups? " -n 1 -r
echo    
if [[ $REPLY =~ ^[Yy]$ ]]
then
	echo -e "${GREEN} Wiping old backups ${RESET}"
	rm -rf ~/.vim~
	rm -f ~/.vimrc~
	rm -f ~/.bashrc~
	echo -e "${GREEN} Deleted old backups ${RESET}"
fi


echo -e "${GREEN} Backing Up and moving configs ${RESET}"

mv ~/.bashrc ~/.bashrc~
mv ~/.vimrc ~/.vimrc~
mv ~/.vim ~/.vim~

echo -e "${GREEN} Preparing ${RESET}"

touch ~/.bashrc ~/.vimrc
mkdir -p ~/.config/wmfs
mkdir -p ~/.vim
mkdir -p ~/.vim/backup
mkdir -p ~/.vim/tmp
mkdir -p ~/.vim/colors


# Create tmp dir
mkdir tmp/

ln -rsf wmfsrc ~/.config/wmfs/wmfsrc

ln -rsf .bashrc ~/.bashrc

mkdir -p ~/.vim
ln -rsf .vimrc ~/.vimrc

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


echo -e "${GREEN} booyah, there you go! ${RESET}"

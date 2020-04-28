if [ 'root' == $(whoami) ]; then
	apt install vim -y
	apt install curl -y
	apt install atom -y
else
	sudo apt-get install vim -y
	sudo apt-get install curl -y
	sudo apt-get install atom -y
fi

echo "create scripts folder"
mkdir ~/.scripts
echo "creating notes"
touch ~/.scripts/notes
echo "creating work"
touch ~/.scripts/work
echo "creating temp folder"
mkdir ~/temp
cd ~/temp
echo "clone open...."
git clone https://github.com/ih4t3youall/open
echo "creating scripts folder"
cp -r open ~/.scripts
#install and configure vim
echo "clone vimconfig"
git clone https://github.com/ih4t3youall/vimconfig
cd vimconfig
echo "installing vim config"
rm ~/.vimrc
cp vimrc ~/.vimrc
cp ideavimrc ~/.ideavimrc

#install pathogen
echo "installing pathongen"
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim


#install bundles
echo "installing bundles"
cd ~/.vim/bundle
git clone https://github.com/preservim/nerdtree.git
git clone https://github.com/leafgarland/typescript-vim.git
git clone git://github.com/burnettk/vim-angular.git 
git clone https://github.com/artur-shaik/vim-javacomplete2.git 

#aliases
echo "creating aliases"
echo 'alias downloads="cd ~/Downloads"' >> ~/.bashrc
echo 'alias documents="cd ~/Documents"' >> ~/.bashrc
echo 'alias workdir="cd ~/Documents/workspace"' >> ~/.bashrc
echo 'alias desktop="cd ~/Desktop"' >> ~/.bashrc
echo 'alias bashrc="vim ~/.bashrc"' >> ~/.bashrc
echo 'alias bashrcu=". ~/.bashrc"' >> ~/.bashrc
echo 'alias notes="vim ~/.scripts/notes"' >> ~/.bashrc
echo 'alias catnotes="cat ~/.scripts/notes"' >> ~/.bashrc
echo 'alias work="vim ~/.scripts/work"' >> ~/.bashrc
echo 'alias catwork="cat ~/.scripts/work"' >> ~/.bashrc
echo 'alias vimrc="vim ~/.vimrc"' >> ~/.bashrc
echo 'alias mkill="xkill;exit"' >> ~/.bashrc
#open
echo "installing open"
echo 'alias open=". ~/.scripts/open/open.sh"' >> ~/.bashrc
#slideshow
echo "installing slideshow"
echo 'alias slideshow="java -jar ~/.scripts/slideshow/target/randomSlideshow-0.0.1-SNAPSHOT.jar"' >> ~/.bashrc
echo "installing vim-mode-plus for atom"
apm install vim-mode-plus
echo "removing temp folder"
. ~/.bashrc
rm -rf ~/temp

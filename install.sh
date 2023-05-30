if [ "root" == $(whoami) ]; then
	echo "i am root"
	apt install vim -y
	apt install curl -y
	apt install atom -y
	apt-get install zsh -y
	echo "if it ask press 2"
	chsh -s /usr/bin/zsh
	echo "install oh-my-zsh"
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
else
	echo "as a mortal user"
	sudo apt-get install vim -y
	sudo apt-get install curl -y
	sudo apt-get install atom -y
	sudo apt-get install xclip -y
	sudo apt-get install zsh -y
	echo "if it ask press 2"
	chsh -s /usr/bin/zsh
	echo "install oh-my-zsh"
	sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
fi


echo "create scripts folder"
mkdir ~/.scripts
echo "creating notes"
cp notes ~/.scripts/notes
echo "creating work"
touch ~/.scripts/work
echo "creating helpers folder"
mkdir ~/.scripts/helpers
echo "creating temp folder"
mkdir ~/temp
cd ~/temp
echo "clone open...."
git clone git@github.com:ih4t3youall/open.git
echo "creating scripts folder"
cp -r open ~/.scripts
#install and configure vim
echo "clone vimconfig"
git clone git@github.com:ih4t3youall/vimconfig.git
cd vimconfig
echo "installing vim config"
rm ~/.vimrc
cp vimrc ~/.vimrc
cp ideavimrc ~/.ideavimrc

echo "installing draftMessage"
cd
cd .scripts/helpers
touch draftMessage.txt


#install pathogen
echo "installing pathongen"
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

#create workdir directory
mkdir ~/Documents/workspace

#java apps instalation
cd
mkdir ~/.scripts/javaApps
cd ~/Documents/workspace
git clone git@github.com:ih4t3youall/scripter.git
cd scripter
mvn clean install
cd target
cp scripter-1.0-SNAPSHOT.jar ~/.scripter/javaApps
cd


#install bundles
echo "installing bundles"
cd ~/.vim/bundle
git clone git@github.com:preservim/nerdtree.git
git clone git@github.com:leafgarland/typescript-vim.git
git clone git://github.com/burnettk/vim-angular.git 
git clone git@github.com:artur-shaik/vim-javacomplete2.git
cd

#aliases
echo "creating aliases"
echo 'alias downloads="cd ~/Downloads"' >> ~/.zshrc
echo 'alias documents="cd ~/Documents"' >> ~/.zshrc
echo 'alias workdir="cd ~/Documents/workspace"' >> ~/.zshrc
echo 'alias desktop="cd ~/Desktop"' >> ~/.zshrc
echo 'alias bashrc="vim ~/.zshrc"' >> ~/.zshrc
echo 'alias bashrcu=". ~/.zshrc"' >> ~/.zshrc
echo 'alias notes="vim ~/.scripts/notes"' >> ~/.zshrc
echo 'alias catnotes="cat ~/.scripts/notes"' >> ~/.zshrc
echo 'alias work="vim ~/.scripts/work"' >> ~/.zshrc
echo 'alias catwork="cat ~/.scripts/work"' >> ~/.zshrc
echo 'alias vimrc="vim ~/.vimrc"' >> ~/.zshrc
echo 'alias mkill="xkill;exit"' >> ~/.zshrc
echo 'alias draftMessage="vim ~/.scripts/helpers/draftMessage.txt"' >> ~/.zshrc
echo 'alias copyMessage="cat ~/.scripts/helpers/draftMessage.txt | xclip"' >> ~/.zshrc
#open
echo "installing open"
echo 'alias open=". ~/.scripts/open/open.sh"' >> ~/.zshrc
#slideshow
echo "installing slideshow"
echo 'alias slideshow="java -jar ~/.scripts/slideshow/target/randomSlideshow-0.0.1-SNAPSHOT.jar"' >> ~/.zshrc
echo "installing vim-mode-plus for atom"
apm install vim-mode-plus
echo "removing temp folder"
. ~/.zshrc
rm -rf ~/temp

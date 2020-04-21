mkdir ~/.scripts
touch ~/.scripts/notes
touch ~/.scripts/work
mkdir ~/temp
cd ~/temp
git clone https://github.com/ih4t3youall/open
cp -r open ~/.scripts
#install and configure vim
git clone https://github.com/ih4t3youall/vimconfig
cd vimconfig
rm ~/.vimrc
cp vimrc ~/.vimrc

#install pathogen
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim


#install bundles
cd ~/.vim/bundle
git clone https://github.com/preservim/nerdtree.git
git clone https://github.com/leafgarland/typescript-vim.git
git clone git://github.com/burnettk/vim-angular.git 
git clone https://github.com/artur-shaik/vim-javacomplete2.git 

#aliases
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
echo 'alias open=". ~/.scripts/open/open.sh"' >> ~/.bashrc
#slideshow
echo 'alias slideshow="java -jar ~/.scripts/slideshow/target/randomSlideshow-0.0.1-SNAPSHOT.jar"' >> ~/.bashrc

rm -rf ~/temp

#!/usr/bin/env bash
# ============================================================================
#  install_linux.sh -> Configuracion inicial en Linux (Debian / Ubuntu, apt)
#  Equivalente a install.sh (macOS). Los comandos SIN equivalente en Linux
#  (p.ej. diskutil, blueutil, xcodegen, brew) se omiten o se adaptan.
# ============================================================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ----------------------------------------------------------------------------
#  1) Paquetes de sistema (apt)
#     imagemagick/pngquant -> to_jpg, to_png, pngmax
#     ffmpeg               -> comprimir_video, acut, to_text (whisper)
#     nmap                 -> ip_camera
#     xclip                -> copyMessage/copylast (reemplazo de pbcopy)
# ----------------------------------------------------------------------------
echo "updating apt"
sudo apt update

echo "installing apt packages"
sudo apt install -y \
  zsh \
  git \
  curl \
  vim \
  xclip \
  arp-scan \
  automake \
  awscli \
  cmake \
  docbook-xsl \
  ffmpeg \
  imagemagick \
  lftp \
  libass-dev \
  libxslt1-dev \
  xsltproc \
  maven \
  nmap \
  nodejs \
  npm \
  pandoc \
  libpcre3-dev \
  pdftk-java \
  pngquant \
  portaudio19-dev \
  protobuf-compiler \
  python3 \
  python3-pip \
  rabbitmq-server \
  rustc \
  cargo \
  shtool \
  unar \
  unrar \
  wget \
  openjdk-8-jdk \
  chromium-chromedriver \
  texlive-latex-recommended \
  texlive-fonts-recommended \
  texlive-latex-extra

# oxipng no esta en apt: se compila con cargo (rust ya instalado)
echo "installing oxipng via cargo"
command -v cargo >/dev/null 2>&1 && cargo install oxipng || true

# nvm (no esta en apt, se instala con su script oficial - compatible)
echo "installing nvm"
if [ ! -d "$HOME/.nvm" ]; then
  curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
fi

# ----------------------------------------------------------------------------
#  2) Dependencias que van por pip
#     openai-whisper -> to_text     pdfly / pymupdf / pipenv -> equivalentes brew
# ----------------------------------------------------------------------------
echo "installing python deps"
pip3 install --break-system-packages openai-whisper pdfly pymupdf pipenv awscli-local

# ----------------------------------------------------------------------------
#  3) Herramientas globales de npm
# ----------------------------------------------------------------------------
echo "installing global npm tools"
sudo npm install -g @angular/cli cordova ionic

# ----------------------------------------------------------------------------
#  4) zsh + oh-my-zsh
# ----------------------------------------------------------------------------
echo "installing oh-my-zsh"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi
command -v zsh >/dev/null 2>&1 && chsh -s "$(command -v zsh)" 2>/dev/null || true

cd "$SCRIPT_DIR"

# ----------------------------------------------------------------------------
#  5) Carpetas / scripts / vim (igual que en macOS)
# ----------------------------------------------------------------------------
echo "create scripts folder"
mkdir -p ~/.scripts
echo "creating notes"
cp notes ~/.scripts/notes
echo "creating work"
touch ~/.scripts/work
echo "creating helpers folder"
mkdir -p ~/.scripts/helpers
echo "creating temp folder"
mkdir -p ~/temp
cd ~/temp

echo "clone vimconfig"
git clone git@github.com:ih4t3youall/vimconfig.git
cd vimconfig
echo "installing vim config"
rm -f ~/.vimrc
cp vimrc ~/.vimrc
cp ideavimrc ~/.ideavimrc

echo "installing draftMessage"
cd
cd .scripts/helpers
touch draftMessage.txt

#install pathogen
echo "installing pathogen"
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

#create workdir directory
mkdir -p ~/Documents/workspace

#java apps
cd
mkdir -p ~/.scripts/javaApps
cd ~/Documents/workspace
git clone git@github.com:ih4t3youall/scripter.git
cd scripter
mvn clean install
cd target
cp scripter-1.0-SNAPSHOT.jar ~/.scripts/javaApps
cd

#vim bundles
echo "installing bundles"
cd ~/.vim/bundle
git clone git@github.com:preservim/nerdtree.git
git clone git@github.com:leafgarland/typescript-vim.git
git clone git://github.com/burnettk/vim-angular.git
git clone git@github.com:artur-shaik/vim-javacomplete2.git
cd

# ----------------------------------------------------------------------------
#  6) Aliases (version Linux)
#     - pbcopy -> xclip -selection clipboard
#     - diskutil / arduinoPort (tty.*) -> SIN equivalente en Linux: se omiten
#     - to_jpg/to_png -> usan magick o convert (ImageMagick 6/7)
# ----------------------------------------------------------------------------
echo "creating aliases"
cat >> ~/.zshrc <<'ALIASES'

# ---- config (agregado por install_linux.sh) ----
set -o vi

export MAVEN_HOME="$HOME/Documents/maven/bin"
export PATH=$PATH:$MAVEN_HOME

# navegacion
alias downloads="cd ~/Downloads"
alias documents="cd ~/Documents"
alias workdir="cd ~/Documents/workspace"
alias desktop="cd ~/Desktop"
alias claude="cd ~/Documents/Claude/Projects"
alias techmag="cd ~/Documents/techmag"
alias disenio="cd ~/Documents/diseño"
alias afinity="cd ~/Documents/afinity"
alias 3dprinter="cd ~/Documents/3dprinter"

# edicion / notas
alias bashrc="vim ~/.zshrc"
alias bashrcu=". ~/.zshrc"
alias notes="vim ~/.scripts/notes"
alias catnotes="cat ~/.scripts/notes"
alias work="vim ~/.scripts/work"
alias catwork="cat ~/.scripts/work"
alias vimrc="vim ~/.vimrc"
alias draftMessage="vim ~/.scripts/helpers/draftMessage.txt"

# red
alias localIP="ip addr | grep 192"
alias myip="ip addr | grep 'inet 192' | awk '{print \$2}'"
alias ip_camera="sudo nmap -sn 192.168.1.0/24 | grep -i h8c"
# arduinoPort: en Linux el patron es /dev/ttyUSB* o /dev/ttyACM*
alias arduinoPort="ls /dev/ttyUSB* /dev/ttyACM* 2>/dev/null"

# multimedia / helpers
alias cleanPng="bash ~/.scripts/helpers/cleanPng.sh"
alias comprimir_video='~/.scripts/helpers/comprimir_video.sh'
alias to_text="python3 ~/.scripts/helpers/transcribir.py"
alias acut="~/.scripts/helpers/audio_cut.sh"
alias to_jpg='f(){ local im=$(command -v magick || command -v convert); "$im" "$1" -resize "1920x1920>" -strip -quality 75 -interlace Plane "${1%.*}_opt.jpg"; }; f'
alias to_png='f(){ local im=$(command -v magick || command -v convert); "$im" "$1" -resize "1920x1920>" -strip png:- | pngquant --quality=40-80 --speed 1 --force --output "${1%.*}_opt.png" -; }; f'
alias slideshow="java -jar ~/.scripts/slideshow/target/randomSlideshow-0.0.1-SNAPSHOT.jar"

# clipboard (Linux: xclip reemplaza a pbcopy)
alias catMessage="cat ~/.scripts/helpers/draftMessage.txt"
alias copyMessage="cat ~/.scripts/helpers/draftMessage.txt | xclip -selection clipboard"
alias copylast="cat ~/.scripts/helpers/draftMessage.txt | tail -1 | xclip -selection clipboard"

# python
alias p=python3
alias p3="python3"
alias pip="pip --break-system-packages"

# apps / servidores
alias idea=". ~/.scripts/intellij/idea.sh"
alias airdrop="java -jar airdrop.jar"
alias hostinger="ssh ih4t3youall@187.127.22.210"
alias hostingerRoot="echo lancia.stratos && ssh root@187.127.22.210"
alias hostingerIp="echo 187.127.22.210"
alias domotica_url="echo http://187.127.22.210:5000/"

# nvm
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && source "$NVM_DIR/nvm.sh"

# pngmax
[ -f ~/bin/pngmax.zsh ] && source ~/bin/pngmax.zsh
# ---- fin config ----
ALIASES

echo "removing temp folder"
. ~/.zshrc 2>/dev/null || true
rm -rf ~/temp

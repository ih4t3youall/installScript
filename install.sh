#!/usr/bin/env bash
# ============================================================================
#  install.sh  ->  Configuracion inicial de la Mac desde cero (macOS / brew)
#  Version Linux equivalente: install_linux.sh
# ============================================================================
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# ----------------------------------------------------------------------------
#  1) Homebrew (gestor de paquetes)
# ----------------------------------------------------------------------------
echo "checking homebrew"
if ! command -v brew >/dev/null 2>&1; then
  echo "installing homebrew"
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
fi
# cargar brew en esta sesion (Apple Silicon)
[ -x /opt/homebrew/bin/brew ] && eval "$(/opt/homebrew/bin/brew shellenv)"

# ----------------------------------------------------------------------------
#  2) Programas de terminal (formulas de brew)
#     Incluye todo lo instalado en la terminal + lo necesario para los alias:
#     imagemagick/pngquant/oxipng -> to_jpg, to_png, pngmax
#     ffmpeg                      -> comprimir_video, acut, to_text (whisper)
#     nmap                        -> ip_camera
#     maven/node/nvm/corretto     -> slideshow, airdrop, proyectos java/js
# ----------------------------------------------------------------------------
echo "installing brew formulae"
brew install \
  zsh \
  git \
  arp-scan \
  automake \
  awscli \
  awscli-local \
  blueutil \
  cmake \
  deno \
  docbook-xsl \
  ffmpeg \
  imagemagick \
  jenv \
  lftp \
  libass \
  librist \
  libxslt \
  maven \
  nmap \
  node \
  nvm \
  oxipng \
  pandoc \
  pcre \
  pdfly \
  pdftk-java \
  pipenv \
  pngquant \
  portaudio \
  protobuf \
  pymupdf \
  python@3.10 \
  rabbitmq \
  rust \
  shtool \
  unar \
  wget \
  xcodegen

echo "installing brew casks"
brew install --cask \
  chromedriver \
  corretto@8 \
  mactex-no-gui \
  miniconda \
  rar

# ----------------------------------------------------------------------------
#  3) Dependencias que NO vienen de brew
#     openai-whisper -> to_text (transcribir.py)   [necesita ffmpeg, ya instalado]
#     angular/cordova/ionic -> herramientas de terminal instaladas
# ----------------------------------------------------------------------------
echo "installing python deps (whisper)"
pip3 install --break-system-packages openai-whisper

echo "installing global npm tools"
npm install -g @angular/cli cordova ionic

# ----------------------------------------------------------------------------
#  4) zsh + oh-my-zsh (crea ~/.zshrc base sobre el que se agregan los alias)
# ----------------------------------------------------------------------------
echo "installing oh-my-zsh"
if [ ! -d "$HOME/.oh-my-zsh" ]; then
  RUNZSH=no CHSH=no sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi
# usar zsh como shell por defecto
command -v zsh >/dev/null 2>&1 && chsh -s "$(command -v zsh)" 2>/dev/null || true

# volver al directorio del script (los cp de abajo son relativos a el)
cd "$SCRIPT_DIR"

# ============================================================================
#  A partir de aca: configuracion original (scripts, vim, aliases)
# ============================================================================
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
#slideshow
echo "installing slideshow"
echo 'alias slideshow="java -jar ~/.scripts/slideshow/target/randomSlideshow-0.0.1-SNAPSHOT.jar"' >> ~/.zshrc
echo "installing vim-mode-plus for atom"
apm install vim-mode-plus

# ----------------------------------------------------------------------------
#  Aliases y configuracion que faltaban en el install (tomados de ~/.zshrc)
#  Se agregan con heredoc para conservar el quoting exacto ($, comillas, etc.)
# ----------------------------------------------------------------------------
echo "adding remaining aliases / env / sources"
cat >> ~/.zshrc <<'ALIASES'

# ---- extra config (agregado por install.sh) ----
set -o vi

# homebrew / rutas de herramientas
export HOME_BREW="/opt/homebrew/bin"
export MAVEN_HOME="$HOME/Documents/maven/bin"
export WEBDRIVER_HOME="$HOME/Documents/webdriver/chromedriver-mac-arm64"
export PATH=$PATH:$WEBDRIVER_HOME:$MAVEN_HOME

# navegacion (algunas carpetas se crean a mano luego; el alias se deja igual)
alias claude="cd /Users/martinlequerica/Documents/Claude/Projects"
alias techmag="cd ~/Documents/techmag"
alias disenio="cd ~/Documents/diseño"
alias afinity="cd ~/Documents/afinity"
alias 3dprinter="cd ~/Documents/3dprinter"

# red
alias localIP="ifconfig | grep 192"
alias myip='ifconfig | grep "inet 192" | awk "{print \$2}"'
alias ip_camera="sudo nmap -sn 192.168.1.0/24 | grep -i h8c"
alias arduinoPort="ls /dev/tty.* | grep usbserial"

# disco (macOS)
alias dulist="diskutil list"
alias duunmout="diskutil unmountdisk"

# multimedia / scripts helpers
alias cleanPng="bash ~/.scripts/helpers/cleanPng.sh"
alias comprimir_video='~/.scripts/helpers/comprimir_video.sh'
alias to_text="python3 ~/.scripts/helpers/transcribir.py"
alias acut="~/.scripts/helpers/audio_cut.sh"
alias to_jpg='f(){ magick "$1" -resize "1920x1920>" -strip -quality 75 -interlace Plane "${1%.*}_opt.jpg"; }; f'
alias to_png='f(){ magick "$1" -resize "1920x1920>" -strip png:- | pngquant --quality=40-80 --speed 1 --force --output "${1%.*}_opt.png" -; }; f'

# clipboard (macOS)
alias catMessage="cat ~/.scripts/helpers/draftMessage.txt"
alias copyMessage="cat ~/.scripts/helpers/draftMessage.txt | pbcopy"
alias copylast="cat ~/.scripts/helpers/draftMessage.txt | tail -1 | pbcopy"

# python
alias p=python
alias p3="python3"
alias pip="pip --break-system-packages"

# apps / servidores
alias idea=". ~/.scripts/intellij/idea.sh"
alias airdrop="java -jar airdrop.jar"
alias hostinger="ssh ih4t3youall@187.127.22.210"
alias hostingerRoot="echo lancia.stratos && ssh root@187.127.22.210"
alias hostingerIp="echo 187.127.22.210"
alias domotica_url="echo http://187.127.22.210:5000/"

# homebrew shellenv + pngmax
eval "$(/opt/homebrew/bin/brew shellenv)"
[ -f ~/bin/pngmax.zsh ] && source ~/bin/pngmax.zsh
# ---- fin extra config ----
ALIASES

# NOTA: el driver de Arduino (CH34xVCPDriver.app) esta incluido en el repo,
# pero su instalacion se hace A MANO (abrir la app > Install > aprobar en
# Ajustes del Sistema > Privacidad y Seguridad).

echo "removing temp folder"
. ~/.zshrc
rm -rf ~/temp

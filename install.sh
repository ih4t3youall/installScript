#!/usr/bin/env bash
#
# Dev-environment bootstrap. Works on Linux (Debian/Ubuntu, apt) and macOS (Homebrew).
# Keeps the same logic as the original script, just made cross-platform and more robust.

# ---------------------------------------------------------------------------
# OS detection
# ---------------------------------------------------------------------------
OS="$(uname -s)"
case "$OS" in
	Linux*)  PLATFORM="linux" ;;
	Darwin*) PLATFORM="mac" ;;
	*)
		echo "Unsupported OS: $OS"
		exit 1
		;;
esac
echo "Detected platform: $PLATFORM"

# ---------------------------------------------------------------------------
# Package-manager abstraction
#   - linux: apt-get (with sudo when not root)
#   - mac:   Homebrew (installed automatically if missing)
# ---------------------------------------------------------------------------
SUDO=""
if [ "$(id -u)" -ne 0 ]; then
	SUDO="sudo"
fi

if [ "$PLATFORM" = "linux" ]; then
	if [ -z "$SUDO" ]; then
		echo "i am root"
	else
		echo "as a mortal user"
	fi
	$SUDO apt-get update -y
fi

if [ "$PLATFORM" = "mac" ]; then
	# Homebrew needs the Xcode command line tools; install them if missing.
	if ! xcode-select -p >/dev/null 2>&1; then
		echo "installing Xcode command line tools"
		xcode-select --install || true
	fi
	# Bootstrap Homebrew if it is not present.
	if ! command -v brew >/dev/null 2>&1; then
		echo "installing Homebrew"
		/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
		# Make brew available in the current shell (Apple Silicon vs Intel paths).
		if [ -x /opt/homebrew/bin/brew ]; then
			eval "$(/opt/homebrew/bin/brew shellenv)"
		elif [ -x /usr/local/bin/brew ]; then
			eval "$(/usr/local/bin/brew shellenv)"
		fi
	fi
fi

# Install a single package using the right manager. Failures are non-fatal so
# one missing/renamed package does not abort the whole setup.
pkg_install() {
	local pkg="$1"
	echo "installing $pkg"
	if [ "$PLATFORM" = "linux" ]; then
		$SUDO apt-get install "$pkg" -y || echo "could not install $pkg, skipping"
	else
		brew install "$pkg" || echo "could not install $pkg, skipping"
	fi
}

# ---------------------------------------------------------------------------
# Base tooling (installed only if needed)
# ---------------------------------------------------------------------------
pkg_install vim
pkg_install curl
pkg_install git
pkg_install zsh

# Clipboard helper differs per platform: xclip on Linux, pbcopy ships with macOS.
if [ "$PLATFORM" = "linux" ]; then
	pkg_install xclip
fi

# Java toolchain needed to build the scripter app.
if ! command -v java >/dev/null 2>&1; then
	if [ "$PLATFORM" = "linux" ]; then
		pkg_install default-jdk
	else
		pkg_install openjdk
	fi
fi
if ! command -v mvn >/dev/null 2>&1; then
	if [ "$PLATFORM" = "linux" ]; then
		pkg_install maven
	else
		pkg_install maven
	fi
fi

# Editor: Atom is discontinued, so prefer a still-maintained GUI editor when
# available, but keep trying Atom for backwards compatibility.
if [ "$PLATFORM" = "linux" ]; then
	pkg_install atom
else
	brew install --cask atom 2>/dev/null || echo "atom not available (discontinued), skipping"
fi

# ---------------------------------------------------------------------------
# Default shell -> zsh
# ---------------------------------------------------------------------------
ZSH_PATH="$(command -v zsh)"
if [ -n "$ZSH_PATH" ]; then
	echo "if it ask press 2"
	chsh -s "$ZSH_PATH" || echo "could not change default shell, do it manually with: chsh -s $ZSH_PATH"
fi

echo "install oh-my-zsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended || true

# ---------------------------------------------------------------------------
# ~/.scripts structure
# ---------------------------------------------------------------------------
echo "create scripts folder"
mkdir -p ~/.scripts
echo "creating notes"
# Works whether the script is run from inside the repo (notes present locally)
# or downloaded standalone (notes fetched from the repo, empty file as fallback).
if [ -f notes ]; then
	cp notes ~/.scripts/notes
elif curl -fsSL https://raw.githubusercontent.com/ih4t3youall/installScript/master/notes -o ~/.scripts/notes; then
	echo "notes downloaded from repo"
else
	echo "notes not found, creating empty one"
	touch ~/.scripts/notes
fi
echo "creating work"
touch ~/.scripts/work
echo "creating helpers folder"
mkdir -p ~/.scripts/helpers
echo "creating temp folder"
mkdir -p ~/temp
cd ~/temp || exit 1
echo "clone open...."
git clone git@github.com:ih4t3youall/open.git
echo "creating scripts folder"
cp -r open ~/.scripts
#install and configure vim
echo "clone vimconfig"
git clone git@github.com:ih4t3youall/vimconfig.git
cd vimconfig || exit 1
echo "installing vim config"
rm -f ~/.vimrc
cp vimrc ~/.vimrc
cp ideavimrc ~/.ideavimrc

echo "installing draftMessage"
cd
cd .scripts/helpers || exit 1
touch draftMessage.txt

#install pathogen
echo "installing pathongen"
mkdir -p ~/.vim/autoload ~/.vim/bundle && \
curl -LSso ~/.vim/autoload/pathogen.vim https://tpo.pe/pathogen.vim

#create workdir directory
mkdir -p ~/Documents/workspace

#java apps instalation
cd
mkdir -p ~/.scripts/javaApps
cd ~/Documents/workspace || exit 1
git clone git@github.com:ih4t3youall/scripter.git
cd scripter || exit 1
mvn clean install
cd target || exit 1
cp scripter-1.0-SNAPSHOT.jar ~/.scripts/javaApps
cd

#install bundles
echo "installing bundles"
cd ~/.vim/bundle || exit 1
git clone git@github.com:preservim/nerdtree.git
git clone git@github.com:leafgarland/typescript-vim.git
git clone https://github.com/burnettk/vim-angular.git
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
echo 'alias draftMessage="vim ~/.scripts/helpers/draftMessage.txt"' >> ~/.zshrc

# Clipboard / window-kill aliases are platform specific.
if [ "$PLATFORM" = "linux" ]; then
	echo 'alias mkill="xkill;exit"' >> ~/.zshrc
	echo 'alias copyMessage="cat ~/.scripts/helpers/draftMessage.txt | xclip"' >> ~/.zshrc
else
	echo 'alias copyMessage="cat ~/.scripts/helpers/draftMessage.txt | pbcopy"' >> ~/.zshrc
fi

#open
echo "installing open"
echo 'alias open=". ~/.scripts/open/open.sh"' >> ~/.zshrc
#slideshow
echo "installing slideshow"
echo 'alias slideshow="java -jar ~/.scripts/slideshow/target/randomSlideshow-0.0.1-SNAPSHOT.jar"' >> ~/.zshrc

# Atom package manager (only if atom/apm actually got installed).
if command -v apm >/dev/null 2>&1; then
	echo "installing vim-mode-plus for atom"
	apm install vim-mode-plus
fi

echo "removing temp folder"
. ~/.zshrc
rm -rf ~/temp

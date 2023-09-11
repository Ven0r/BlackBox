#!/bin/bash
echo "-------------------------------------------------------------------"
echo "----- update, upgrade, and dist-upgrade complete, Next Phase ------"
echo "-------------------------------------------------------------------"

sudo apt update
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y

sudo apt install glances fuse build-essential python3-setuptools hexedit exif qbittorrent jq cupp -y

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
./nvim.appimage

git clone https://github.com/LazyVim/starter ~/.config/nvim
chmod u+x nvim.appimage
sudo mv nvim.appimage /usr/local/bin/nvim

cd ~
mkdir Tools
cd ~

echo "-------------------------------------------------------------------"
echo "------------------ Getting SecLists from Github  ------------------"
echo "-------------------------------------------------------------------"

git clone https://github.com/danielmiessler/SecLists.git
cd SecLists
wget https://gist.githubusercontent.com/jhaddix/86a06c5dc309d08580a018c66354a056/raw/96f4e51d96b2203f19f6381c8c545b278eaa0837/all.txt

cd ~

echo "-------------------------------------------------------------------"
echo "---------   Getting PayloadsalltheThings from Github  -------------"
echo "-------------------------------------------------------------------"
git clone https://github.com/swisskyrepo/PayloadsAllTheThings.git

cd ~

mkdir Targets

wget https://raw.githubusercontent.com/Ven0r/OS-setup/master/.zshrc

cd

git config --global user.email "venor.stdout@gmail.com"
git config --global user.name "Venor"

git clone https://github.com/Ven0r/CheatSheets.git

go get -v github.com/projectdiscovery/subfinder/cmd/subfinder

ssh-keygen -t ed25519 -C "venor" -f $HOME/.ssh/venor -q
#source bash-vim-setup.sh

echo "Cleaning Up" &&
	apt -f install &&
	apt -y autoremove &&
	apt -y autoclean &&
	apt -y clean

echo "-------------------------------------------------------------------"
echo "-------------------- System Clean, Rebooting ----------------------"
echo "-------------------------------------------------------------------"

sudo reboot
update os

install zsh
install ohmyzsh
add user: "name"
set user to zshshell
set user to ohmyzsh
change zsh to bira theme

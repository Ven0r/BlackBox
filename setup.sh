#!/bin/bash
echo "-------------------------------------------------------------------"
echo "----- update, upgrade, and dist-upgrade complete, Next Phase ------"
echo "-------------------------------------------------------------------"

sudo apt update
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y

sudo apt install zsh glances fuse build-essential python3-setuptools hexedit golang exif qbittorrent jq cupp -y

curl -LO https://github.com/neovim/neovim/releases/latest/download/nvim.appimage
chmod u+x nvim.appimage
sudo mv nvim.appimage /usr/local/bin/nvim

echo "-------------------------------------------------------------------"
echo "---------               Create User                   -------------"
echo "-------------------------------------------------------------------"

echo "creating venor"
sudo useradd -m -s /usr/bin/zsh venor && echo "venor:toor" | sudo chpasswd
sudo usermod -aG sudo venor
sudo touch /home/venor/.zshrc
sudo chown venor:venor /home/venor/.zshrc
sudo su - venor

echo "setting git global for venor"
git config --global user.email "venor.stdout@gmail.com"
git config --global user.name "Venor"

echo "grab ohmyzsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
echo "change theme in ohmyzsh"
sed -i 's/ZSH_THEME="robbyrussell"/ZSH_THEME="bira"/' ~/.zshrc

echo "setup ssh key"
ssh-keygen -t ed25519 -C "venor" -f $HOME/.ssh/venor -q -N ""

export GOPATH=$HOME/go
export GOROOT=/usr/lib/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

git clone https://github.com/LazyVim/starter ~/.config/nvim

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

mkdir Targets

wget https://raw.githubusercontent.com/Ven0r/OS-setup/master/.zshrc

echo "Cleaning Up" &&
	apt -f install &&
	apt -y autoremove &&
	apt -y autoclean &&
	apt -y clean

echo "-------------------------------------------------------------------"
echo "-------------------- System Clean, Rebooting ----------------------"
echo "-------------------------------------------------------------------"

sudo reboot


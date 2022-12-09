#!/bin/bash

sudo cp /etc/apt/sources.list /etc/apt/sources-list.bak
sudo cp sources.list /etc/apt/

sudo apt update
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y

echo "-------------------------------------------------------------------"
echo "----- update, upgrade, and dist-upgrade complete, Next Phase ------"
echo "-------------------------------------------------------------------"
cd ~
wget https://dl.google.com/go/go1.13.3.linux-amd64.tar.gz
tar -xvf go1.13.3.linux-amd64.tar.gz

echo "-------------------------------------------------------------------"
echo "----- Installing zsh, neovim, chrome, openvpn, +more Next Phase ---"
echo "-------------------------------------------------------------------"

sudo apt install glances zsh neovim build-essential python3-setuptools hexedit exif qbittorrent snapd openvpn git -y

sudo systemctl enable snapd
sudo systemctl start snapd

snap install amass

echo "-------------------------------------------------------------------"
echo "----- Installing zsh, neovim, chrome, openvpn, +more Next Phase ---"
echo "-------------------------------------------------------------------"

cd
mkdir tools
cd tools 

mkdir Lists
cd Lists

wget https://gist.githubusercontent.com/jhaddix/86a06c5dc309d08580a018c66354a056/raw/96f4e51d96b2203f19f6381c8c545b278eaa0837/all.txt
git clone https://github.com/danielmiessler/SecLists.git 
git clone https://github.com/swisskyrepo/PayloadsAllTheThings.git 

cd ..
mkdir Targets

git clone https://github.com/FortyNorthSecurity/EyeWitness.git
git clone https://github.com/blechschmidt/massdns.git
git clone https://github.com/vortexau/dnsvalidator.git

cd massdns
make

echo "-------------------------------------------------------------------"
echo "------------------ Getting SecLists from Github  ------------------"
echo "-------------------------------------------------------------------"

cd ~/tools

echo "-------------------------------------------------------------------"
echo "---------   Getting PayloadsalltheThings from Github  -------------"
echo "-------------------------------------------------------------------"

echo "-------------------------------------------------------------------"
echo "---------- Lots of cool software installed, Next Phase ------------"
echo "-------------------------------------------------------------------"

wget -q https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh
chmod +x install.sh
./install.sh --unattended
ZSH=${ZSH:-~/.oh-my-zsh}

#export SHELL="$ZSH"
# Change default shell to ZSH
chsh -s /usr/bin/zsh
#Fix .zsh path, add $HOME/.local/bin to PATH
sed -i '4iexport PATH=$PATH:$HOME/.local/bin' $HOME/.zshrc

#Change zsh theme
sed -i -e 's/ZSH_THEME=.*/ZSH_THEME="bira"/g' $HOME/.zshrc

#add alias in .zshrc
echo -e 'alias lh="ls -lAh"\nalias la="ls -la"\nalias ll="ls -l"' >> $HOME/.zshrc
echo -e 'alias g="git"\nalias vim="nvim"' >> $HOME/.zshrc

rm install.sh
chsh -s /usr/bin/zsh

git config --global user.email "you@example.com"
git config --global user.name "Your Name"

echo -e 'export GOROOT=/usr/local/go' >> $HOME/.zshrc
echo -e 'export GOPATH=$HOME' >> $HOME/.zshrc
echo -e 'export PATH=$GOPATH/bin:$GOROOT/bin:$PATH' >> $HOME/.zshrc
echo -e 'export PATH=$PATH:/snap/bin' >> $HOME/.zshrc

snap refresh
echo "-------------------------------------------------------------------"
echo "------------------- Installing Go Toolz ---------------------------"
echo "-------------------------------------------------------------------"

cp $HOME/OS-setup/install_scripts/configz/.zshrc $HOME/
cp $HOME/OS-setup/install_scripts/configz/init.vim $HOME/.config/nvim/

source ~/.zshrc

go get -v github.com/projectdiscovery/subfinder/cmd/subfinder
go get -v github.com/OJ/gobuster
go get -v github.com/ffuf/ffuf

sudo mv go /usr/local
echo "-------------------------------------------------------------------"
echo "---------- Installed Oh-my-zsh, Next Phase ------------"
echo "-------------------------------------------------------------------"

ssh-keygen -t rsa -b 4096 -N "" -C "venor@venor.com" -f $HOME/.ssh/venor -q
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


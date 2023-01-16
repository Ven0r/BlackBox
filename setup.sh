#!/bin/bash
echo "-------------------------------------------------------------------"
echo "----- update, upgrade, and dist-upgrade complete, Next Phase ------"
echo "-------------------------------------------------------------------"

sudo apt update
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y

sudo apt install glances build-essential python3-setuptools hexedit exif qbittorrent jq cupp -y

cd ~
mkdir Tools

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

git config --global user.email "venor.stdout@gmail.com"
git config --global user.name "Venor"


go get -v github.com/projectdiscovery/subfinder/cmd/subfinder


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


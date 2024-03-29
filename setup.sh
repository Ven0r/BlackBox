#!/bin/bash
echo "-------------------------------------------------------------------"
echo "----- update, upgrade, and dist-upgrade complete, Next Phase ------"
echo "-------------------------------------------------------------------"

sudo apt update
sudo apt-get upgrade -y
sudo apt-get dist-upgrade -y

sudo apt install zsh glances npm fuse build-essential python3-setuptools hexedit exif qbittorrent jq cupp libssl-dev libcurl4-openssl-dev -y

wget https://golang.org/dl/go1.21.7.linux-amd64.tar.gz
sudo tar -xvf go1.21.7.linux-amd64.tar.gz -C /usr/local

echo "-------------------------------------------------------------------"
echo "---------               Create User                   -------------"
echo "-------------------------------------------------------------------"

echo "creating venor"
sudo useradd -m -s /usr/bin/zsh venor && echo "venor:toor" | sudo chpasswd
sudo usermod -aG sudo venor
sudo touch /home/venor/.zshrc
sudo chown venor:venor /home/venor/.zshrc
sudo su - venor -c '

echo "setting git global for venor"
git config --global user.email "venor.stdout@gmail.com"
git config --global user.name "Venor"

echo "grab ohmyzsh"
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
echo "change theme in ohmyzsh"
wget -O ~/.zshrc https://raw.githubusercontent.com/Ven0r/OS-setup/master/.zshrc

echo "setup ssh key"
ssh-keygen -t ed25519 -C "venor" -f $HOME/.ssh/venor -q -N ""

export GOPATH=$HOME/go
export GOROOT=/usr/lib/go
export PATH=$PATH:$GOROOT/bin:$GOPATH/bin

go install -v github.com/projectdiscovery/httpx/cmd/httpx@latest

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
go install github.com/OWASP/Amass/v3@latest

echo "-------------------------------------------------------------------"
echo "---------             Install Subfinder               -------------"
echo "-------------------------------------------------------------------"

mkdir Tools
cd Tools

cd ~
mkdir Tools
cd Tools
git clone https://github.com/vortexau/dnsvalidator.git
cd dnsvalidator
sudo python3 setup.py install
dnsvalidator -tL https://public-dns.info/nameservers.txt -threads 20 -o resolvers.txt
mv resolvers.txt ~
cd ~

'

echo "Cleaning Up" &&
	apt -f install &&
	apt -y autoremove &&
	apt -y autoclean &&
	apt -y clean

echo "-------------------------------------------------------------------"
echo "-------------------- System Clean, Rebooting ----------------------"
echo "-------------------------------------------------------------------"

sudo reboot
